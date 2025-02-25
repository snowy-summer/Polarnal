//
//  NoteContentView.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI
import Combine
import EnumHelper

struct NoteContentView: View {
    
    @ObservedObject private var noteContentViewModel: NoteListViewModel
    
    init(noteContentViewModel: NoteListViewModel) {
        self.noteContentViewModel = noteContentViewModel
    }
    
    var body: some View {
        List {
            
            HStack {
                TextField("제목", text: $noteContentViewModel.contentTitle)
                    .font(.title)
                    .frame(height: 60)
                
                DatePicker("", selection: $noteContentViewModel.noteDate,
                           displayedComponents: .date)
                .labelsHidden()
            }
            .padding()
            
            ForEach(noteContentViewModel.noteContents,
                    id: \.id) { noteContent in
                
                NoteContentCell(content: noteContent,
                                noteContentViewModel: noteContentViewModel,
                                index: noteContent.index
                )
                .contextMenu {
                    Button(role: .destructive, action: {
                        noteContentViewModel.contentApply(.deleteContent(noteContent))
                    }, label: {
                        Label("삭제", systemImage: "trash")
                    })
                    
                }
                .swipeActions(edge: .trailing,
                              allowsFullSwipe: false) {
                    Button(role: .destructive, action: {
                        noteContentViewModel.contentApply(.deleteContent(noteContent))
                    }, label: {
                        Label("삭제", systemImage: "trash")
                    })
                }
                
                
            }
            
#if os(macOS)
            NoteContentToolView(noteContentViewModel: noteContentViewModel, isMacOS: true)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .frame(maxWidth: .infinity)
                .frame(height: 120)
#else
            NoteContentToolView(noteContentViewModel: noteContentViewModel, isMacOS: false)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .frame(maxWidth: .infinity)
                .frame(height: 120)
#endif
        }
    }
    
}

//MARK: - ContentCell
struct NoteContentCell: View {
    
    @ObservedObject private var noteContentViewModel: NoteListViewModel
    @State private var loadedImages: [PlatformImage] = []
    private let content : NoteContentDataDB
    private let index: Int
    
    init(content: NoteContentDataDB,
         noteContentViewModel: NoteListViewModel,
         index: Int) {
        self.content = content
        self.noteContentViewModel = noteContentViewModel
        self.index = index
    }
    
    var body: some View {
        VStack {
            if let type = NoteContentType(rawValue: content.type) {
                switch type {
                case .text:
                    NoteTextField(noteText: content.textValue,
                                  noteContentViewModel: noteContentViewModel,
                                  index: index)
                    
                case .image:
//                                        let images = (content.imagePaths ?? []).compactMap {
//                                            LocaleFileManager.shared.loadImage(from: $0.id)
//                                        }
                    
                    if !loadedImages.isEmpty {
#if os(macOS)
                        Image(nsImage: loadedImages[0])
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
#elseif os(iOS)
                        Image(uiImage: loadedImages[0])
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
#endif
                        
                    }
                }
            }
        }
        .onAppear {
            loadImages()
        }
        .background(Color.listBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func loadImages() {
        Task {
            let images = await loadImagesFromPaths(content.imagePaths ?? [])
            loadedImages = images
        }
    }
    
    private func loadImagesFromPaths(_ paths: [ImagePath]) async -> [PlatformImage] {
        var images: [PlatformImage] = []
        
        for path in paths {
            if let image = ImageStorageManager.shared.loadImage(from: path.id) {
                images.append(image)
            } else {
                if let image = await ImageStorageManager.shared.fetchImageFromCloudKit(recordName: path.cloudPath) {
                    images.append(image)
                }
            }
        }
        
        return images
    }
    
    
}

//MARK: - TextField
struct NoteTextField: View {
    
    @ObservedObject var noteContentViewModel: NoteListViewModel
    @State var noteText: String
    @State private var textFieldHeight: CGFloat = 44
    private let index: Int
    
    init(noteText: String,
         noteContentViewModel: NoteListViewModel,
         index: Int) {
        self.noteText = noteText
        self.noteContentViewModel = noteContentViewModel
        self.index = index
        updateTextFieldHeight()
    }
    
    var body: some View {
        TextEditor(text: $noteText)
            .font(.title3)
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
            .frame(minHeight: textFieldHeight)
            .padding(8)
            .onChange(of: noteText) { oldValue, newValue in
                noteContentViewModel.contentApply(.editText(of: index,
                                                            what: newValue))
                updateTextFieldHeight()
            }
    }
    
}

extension NoteTextField {
    private func updateTextFieldHeight() {
#if os(iOS)
        let font = UIFont.systemFont(ofSize: 16)
        let textWidth = UIScreen.main.bounds.width - 64
        let boundingRect = NSString(string: noteText)
            .boundingRect(with: CGSize(width: textWidth,
                                       height: .infinity),
                          options: .usesLineFragmentOrigin,
                          attributes: [.font: font],
                          context: nil)
        
        let lineHeight = font.lineHeight
        let lineCount = Int(ceil(boundingRect.height / lineHeight))
        
        textFieldHeight = max(40, CGFloat(lineCount) * lineHeight + 26)
#elseif os(macOS)
        let font = NSFont.systemFont(ofSize: 20)
        let textWidth = NSScreen.main?.frame.width ?? 800 - 64
        let lineHeight = font.ascender - font.descender + font.leading
        
        let boundingRect = NSString(string: noteText)
            .boundingRect(with: CGSize(width: textWidth, height: .infinity),
                          options: .usesLineFragmentOrigin,
                          attributes: [.font: font],
                          context: nil)
        
        let lineCount = Int(ceil(boundingRect.height / lineHeight))
        textFieldHeight = max(44, CGFloat(lineCount) * lineHeight + 26)
#endif
    }
}

//MARK: - ToolView
struct NoteContentToolView: View {
    @State private var selectedType: NoteContentToolType? = nil
    @ObservedObject private var noteContentViewModel: NoteListViewModel
    
    private let rectangleWidth: CGFloat
    private let rectangleHeight: CGFloat
    private var rectangleCornerRadius: CGFloat {
        rectangleWidth / 2
    }
    private let imageWidth: CGFloat
    private let imageHeight: CGFloat
    
    init(noteContentViewModel: NoteListViewModel, isMacOS: Bool) {
        self.noteContentViewModel = noteContentViewModel
        self.rectangleWidth = isMacOS ? 44 : 80
        self.rectangleHeight = isMacOS ? 44 : 80
        self.imageWidth = isMacOS ? 20 : 32
        self.imageHeight = isMacOS ? 20 : 32
    }
    
    var body: some View {
        HStack(spacing: 40) {
            ForEach(NoteContentToolType.allCases) { type in
                toolButton(for: type)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.listBackground)
    }
    
    @ViewBuilder
    private func toolButton(for type: NoteContentToolType) -> some View {
        let isSelected = selectedType == type
        
        switch type {
        case .text:
            ZStack {
                contentBackground(isSelected: isSelected)
                Image(systemName: "text.page")
                    .resizable()
                    .frame(width: imageWidth, height: imageHeight)
            }
            .onTapGesture {
                withAnimation(.linear(duration: 0.3)) {
                    selectedType = (selectedType == type) ? nil : type
                }
                noteContentViewModel.contentApply(.addTextField)
            }
            
        case .image:
            PhotoPicker(selectedImages: $noteContentViewModel.noteContentPhotoData) {
                ZStack {
                    contentBackground(isSelected: isSelected)
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: imageWidth, height: imageHeight)
                }
            } dismiss: {
                withAnimation(.linear(duration: 0.3)) {
                    selectedType = type
                }
                noteContentViewModel.contentApply(.addImage)
            }
            .buttonStyle(.plain)
        }
    }
    
    private func contentBackground(isSelected: Bool) -> some View {
        RoundedRectangle(cornerRadius: isSelected ? 8 : rectangleCornerRadius)
            .fill(isSelected ? Color.blue : Color.gray)
            .frame(width: rectangleWidth, height: rectangleHeight)
            .animation(.linear(duration: 0.3), value: isSelected)
    }
}

@IdentifiableEnum
enum NoteContentToolType: CaseIterable {
    case text
    case image
}

