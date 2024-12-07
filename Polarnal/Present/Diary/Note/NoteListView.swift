//
//  NoteListView.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI

struct NoteListView: View {
    
    @ObservedObject private var stateViewModel: DiaryStateViewModel
    @ObservedObject private var noteListViewModel: NoteListViewModel
    
    init(stateViewModel: DiaryStateViewModel,
         noteListViewModel: NoteListViewModel) {
        
        self.stateViewModel = stateViewModel
        self.noteListViewModel = noteListViewModel
    }
    
    var body: some View {
        List {
            ForEach(noteListViewModel.noteList,
                    id: \.id) { note in
                NoteListCell(note: note)
                    .background(
                        Button(action: {
                            stateViewModel.apply(.selectNote(note))
                            noteListViewModel.apply(.selectNote(note))
                        }) {
                            Color.clear
                        }
                        .frame(maxWidth: .infinity,
                               maxHeight: .infinity)
                    )
                    .contextMenu {
                        Button(action: {
                            noteListViewModel.apply(.deleteNote(note))
                        }) {
                            Label("삭제", systemImage: "trash")
                        }
                    }
            }
        }
    }
}
