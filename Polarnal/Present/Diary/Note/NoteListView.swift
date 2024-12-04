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
    
    var body: some View {
        List {
//            ForEach(stateViewModel.selectedFolder?.noteList ?? []) { note in
//                NoteListCell(note: note)
//                    .contextMenu {
//                        Button(action: {
//                            noteListViewModel.apply(.deleteNote(note))
//                        }) {
//                            Label("삭제", systemImage: "trash")
//                        }
//                    }
//                    .onTapGesture {
//                        stateViewModel.apply(.selectNote(note))
//                    }
//            }
            // 1안
            
            ForEach(noteListViewModel.noteList,
                    id: \.id) { note in
                            NoteListCell(note: note)
                                .contextMenu {
                                    Button(action: {
                                        noteListViewModel.apply(.deleteNote(note))
                                    }) {
                                        Label("삭제", systemImage: "trash")
                                    }
                                }
                                .onTapGesture {
                                    stateViewModel.apply(.selectNote(note))
                                }
                        }
                    //2안
        }
    }
}
