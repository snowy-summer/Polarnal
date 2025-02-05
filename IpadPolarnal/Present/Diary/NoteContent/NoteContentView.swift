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
            TextField("제목", text: $noteContentViewModel.contentTitle)
                .font(.title)
                .frame(height: 60)
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
                    let images = content.imagePaths.compactMap {
                        LocaleFileManager.shared.loadImage(from: $0.id)
                    }
                    
                    if !images.isEmpty {
#if os(macOS)
                        Image(nsImage: images[0])
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
#elseif os(iOS)
                        Image(uiImage: images[0])
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
#endif
                        
                    }
                }
            }
        }
        .background(Color.listBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
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
            .font(.title2)
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
        let font = UIFont.systemFont(ofSize: 20)
        let textWidth = UIScreen.main.bounds.width - 64
        let lineHeight = font.lineHeight
#elseif os(macOS)
        let font = NSFont.systemFont(ofSize: 20)
        let textWidth = NSScreen.main?.frame.width ?? 800 - 64
        let lineHeight = font.ascender - font.descender + font.leading
#endif
        
        let boundingRect = NSString(string: noteText)
            .boundingRect(with: CGSize(width: textWidth, height: .infinity),
                          options: .usesLineFragmentOrigin,
                          attributes: [.font: font],
                          context: nil)
        
        let lineCount = Int(ceil(boundingRect.height / lineHeight))
        textFieldHeight = max(44, CGFloat(lineCount) * lineHeight + 26)
    }
    
}

//MARK: - ToolView
struct NoteContentToolView: View {
    @State private var selectedCircleIndex: Int? = nil
    @State private var select = false
    @ObservedObject private var noteContentViewModel: NoteListViewModel
    
    private let rectangleWidth: CGFloat
    private let rectangleHeight: CGFloat
    private var rectangleCornerRadius: CGFloat {
        rectangleWidth / 2
    }
    private let imageWidth: CGFloat
    private let imageHeight: CGFloat
    
    init(noteContentViewModel: NoteListViewModel,
         isMacOS: Bool) {
        self.noteContentViewModel = noteContentViewModel
        
        rectangleWidth = isMacOS ? 44 : 80
        rectangleHeight = isMacOS ? 44 : 80
        imageWidth = isMacOS ? 20 : 32
        imageHeight = isMacOS ? 20 : 32
    }
    
    var body: some View {
        HStack(spacing: 40) {
            ForEach(NoteContentToolType.allCases) { type in
                ZStack {
                    RoundedRectangle(cornerRadius: select ? 8 : rectangleCornerRadius)
                        .fill(.gray)
                        .frame(width: rectangleWidth,
                               height: rectangleHeight)
                        .transition(.opacity)
                        .animation(.linear(duration: 0.3),
                                   value: select)
                    
                    
                    switch type {
                    case .text:
                        Image(systemName: "text.page")
                            .resizable()
                            .frame(width: imageWidth,
                                   height: imageHeight)
                    case .image:
                        
                        PhotoPicker(selectedImages: $noteContentViewModel.noteContentPhotoData) {
                            Image(systemName: "photo")
                                .resizable()
                                .background(Color.clear)
                                .frame(width: imageWidth,
                                       height: imageHeight)
                                
                        } dismiss: {
                            noteContentViewModel.contentApply(.addImage)
                        }
                       
                    }
                }
                .onTapGesture {
                    select.toggle()
                    
                    switch type {
                    case .text:
                        noteContentViewModel.contentApply(.addTextField)
                    case .image:
//                        noteContentViewModel.contentApply(.showPhotoPicker)
                        return
                    }
                    
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.listBackground)
        .sheet(item: $noteContentViewModel.noteContentsSheetType, onDismiss: {
            noteContentViewModel.contentApply(.addImage)
        }, content: { _ in
#if os(iOS)
//                        PhotoPicker(selectedImages: $noteContentViewModel.noteContentPhotoData)
#endif
        })
        
    }
}

@IdentifiableEnum
enum NoteContentToolType: CaseIterable {
    case text
    case image
}

