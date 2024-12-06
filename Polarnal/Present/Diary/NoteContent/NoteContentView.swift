//
//  NoteContentView.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI

struct NoteContentView: View {
    
    @ObservedObject private var noteContentViewModel: NoteContentViewModel
    
    init(noteContentViewModel: NoteContentViewModel) {
        self.noteContentViewModel = noteContentViewModel
    }
    
    var body: some View {
        List {
            TextField("제목", text: $noteContentViewModel.title)
                .font(.title)
                .frame(height: 80)
                .padding()
            ForEach(noteContentViewModel.noteContents.indices,
                    id: \.self) { index in
                let content = noteContentViewModel.noteContents[index]
                
                NoteContentCell(
                    type: content.type,
                    noteText: Binding(
                        get: { noteContentViewModel.noteContents[index].textContent },
                        set: { newValue in noteContentViewModel.apply(.editText(of: index,
                                                                                what: newValue)) }
                    )
                )
            }.listRowSeparator(.hidden)
            
            NoteContentToolView(noteContentViewModel: noteContentViewModel)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .frame(maxWidth: .infinity)
                .frame(height: 120)
        }
    }
    
}

struct NoteContentCell: View {
    
    private let type: NoteContentType
    @Binding private var noteText: String
    
    init(type: NoteContentType,
         noteText: Binding<String>) {
        self.type = type
        self._noteText = noteText
    }
    
    var body: some View {
        switch type {
        case .text:
            NoteTextField(noteText: $noteText)
            
        case .image:
            Image(.ex)
                .resizable()
        }
    }
    
    
    
    
}

struct NoteTextField: View {
    
    @Binding var noteText: String
    @State private var textFieldHeight: CGFloat = 44
    
    var body: some View {
        TextEditor(text: $noteText)
            .font(.title2)
            .scrollContentBackground(.hidden)
            .frame(minHeight: textFieldHeight)
            .padding(8)
            .onChange(of: noteText) { oldValue, newValue in
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
    @ObservedObject private var noteContentViewModel: NoteContentViewModel
    
    init(noteContentViewModel: NoteContentViewModel) {
        self.noteContentViewModel = noteContentViewModel
    }
    
    enum NoteContentToolType: CaseIterable, Identifiable {
        case text
        case image
        
        var id: String {
            switch self {
            case .text:
                return "text"
                
            case .image:
                return "image"
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 40) {
            ForEach(NoteContentToolType.allCases) { type in
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
                            noteContentViewModel.apply(.addTextField)
                        case .image:
                            noteContentViewModel.apply(.addImage)
                        }
                        
                    }
            }
        }
    }
}
