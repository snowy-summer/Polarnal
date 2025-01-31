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
                .frame(height: 80)
                .padding()
            ForEach(noteContentViewModel.noteContents.indices,
                    id: \.self) { index in
                let content = noteContentViewModel.noteContents[index]
                
                NoteContentCell(content: content,
                                noteContentViewModel: noteContentViewModel,
                                index: index
                )
                .swipeActions(edge: .trailing,
                              allowsFullSwipe: false) {
                    Button(role: .destructive, action: {
                        noteContentViewModel.contentApply(.deleteContent(index))
                    }, label: {
                        Label("삭제", systemImage: "trash")
                    })
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                }
            }.listRowSeparator(.hidden)
            
            NoteContentToolView(noteContentViewModel: noteContentViewModel)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .frame(maxWidth: .infinity)
                .frame(height: 120)
        }
    }
    
}

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
                    let images = content.imageValue.compactMap { imageData -> UIImage? in
                        guard let image = UIImage(data: imageData) else {
                            LogManager.log("이미지 변환 실패: \(imageData)")
                            return nil
                        }
                        return image
                    }
                    
                    if !images.isEmpty {
                        Image(uiImage: images[0])
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .background(Color.listBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    
    
    
}

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
        let font = UIFont.systemFont(ofSize: 20)
        let textWidth = UIScreen.main.bounds.width - 64
        let boundingRect = NSString(string: noteText)
            .boundingRect(with: CGSize(width: textWidth,
                                       height: .infinity),
                          options: .usesLineFragmentOrigin,
                          attributes: [.font: font],
                          context: nil)
        
        let lineHeight = font.lineHeight
        let lineCount = Int(ceil(boundingRect.height / lineHeight))
        
        textFieldHeight = max(44, CGFloat(lineCount) * lineHeight + 26)
    }
    
}

struct NoteContentToolView: View {
    @State private var selectedCircleIndex: Int? = nil
    @State private var select = false
    @ObservedObject private var noteContentViewModel: NoteListViewModel
    
    init(noteContentViewModel: NoteListViewModel) {
        self.noteContentViewModel = noteContentViewModel
    }
    
    var body: some View {
        HStack(spacing: 40) {
            ForEach(NoteContentToolType.allCases) { type in
                ZStack {
                    RoundedRectangle(cornerRadius: select ? 12 : 40)
                        .fill(.gray)
                        .frame(width: 80, height: 80)
                        .transition(.opacity)
                        .animation(.linear(duration: 0.3),
                                   value: select)
                        .onTapGesture {
                            select.toggle()
                            
                            switch type {
                            case .text:
                                noteContentViewModel.contentApply(.addTextField)
                            case .image:
                                noteContentViewModel.contentApply(.showPhotoPicker)
                            }
                            
                        }
                    
                    switch type {
                    case .text:
                        Image(systemName: "text.page")
                            .resizable()
                            .frame(width: 32, height: 32)
                    case .image:
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 32, height: 32)
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
            PhotoPicker(selectedImages: $noteContentViewModel.noteContentPhotoData)
        })
        
    }
}

@IdentifiableEnum
enum NoteContentToolType: CaseIterable {
    case text
    case image
}
