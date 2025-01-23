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
                
                NoteContentCell(type: content.type,
                                noteContentViewModel: noteContentViewModel,
                                index: index
//                    noteText: Binding(
//                        get: { content.textContent },
//                        set: { newValue in noteContentViewModel.contentApply(.editText(of: index,
//                                                                                what: newValue)) }
//                    )
                )
                .swipeActions(edge: .trailing,
                              allowsFullSwipe: false) {
                    Button(role: .destructive, action: {
                        noteContentViewModel.contentApply(.deleteContent(index))
                    }, label: {
                        Label("삭제", systemImage: "trash")
                    })
                    
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
    private let type: NoteContentType
    private let index: Int
    
    init(type: NoteContentType,
         noteContentViewModel: NoteListViewModel,
         index: Int) {
        self.type = type
        self.noteContentViewModel = noteContentViewModel
        self.index = index
    }
    
    var body: some View {
        VStack {
            switch type {
            case .text:
                NoteTextField(noteContentViewModel: noteContentViewModel,
                              index: index)
                
            case .image:
                Image(.ex)
                    .resizable()
            }
        }
        .background(Color.listBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    
    
    
}

struct NoteTextField: View {
    
    @ObservedObject var noteContentViewModel: NoteListViewModel
    @State var noteText: String = ""
    @State private var textFieldHeight: CGFloat = 44
    private let index: Int
    
    init(noteContentViewModel: NoteListViewModel,
         index: Int) {
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
                                noteContentViewModel.contentApply(.addImage)
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
    }
}

@IdentifiableEnum
enum NoteContentToolType: CaseIterable {
    case text
    case image
}
