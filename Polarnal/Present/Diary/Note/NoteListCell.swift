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
                            .foregroundStyle(.black)
                        Text("\(13)")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(.black)
                    }
                }
            VStack(alignment: .leading) {
                Text("임시 제목")
                    .bold()
                Text("임시 내용")
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
