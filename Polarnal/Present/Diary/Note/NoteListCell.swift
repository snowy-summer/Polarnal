//
//  NoteListCell.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI

struct NoteListCell: View {
    @StateObject private var viewModel: NoteListCellViewModel
    
    init(note: Note) {
        _viewModel = StateObject(wrappedValue: NoteListCellViewModel(note: note))
    }
    
    var body: some View {
        HStack(alignment: .top) {
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemGray5))
                .frame(width: 60,
                       height: 100)
                .overlay {
                    VStack {
                        Text("Apr")
                            .bold()
                            .foregroundStyle(Color.normalText)
                        Text("\(13)")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(Color.normalText)
                    }
                }
            VStack(alignment: .leading) {
                Text(viewModel.note.title)
                    .bold()
                if !viewModel.note.contents.isEmpty,
                   let text = viewModel.note.contents.first?.textValue {
                    Text("\(text)")
                }
            }
            Spacer()
            Image(.ex)
                .resizable()
                .frame(width: 100,
                       height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
}
