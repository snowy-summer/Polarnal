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
#if os(macOS)
        List {
            ForEach(noteListViewModel.noteList,
                    id: \.id) { note in
               
                NoteListCell(note: note,
                             isMacOS: true)
                .contentShape(Rectangle())
                .onTapGesture {
                    noteListViewModel.apply(.selectNote(note))
                    stateViewModel.apply(.selectNote(note))
                }
                .contextMenu {
                    Button(action: {
                        noteListViewModel.apply(.deleteNote(note))
                    }) {
                        Label("삭제", systemImage: "trash")
                    }
                }
                    
            }
                    .scrollContentBackground(.hidden)
        }
        
#else
        
        List {
            ForEach(noteListViewModel.noteList,
                    id: \.id) { note in
                NoteListCell(note: note)
                    .background(
                        Button(action: {
                            noteListViewModel.apply(.selectNote(note))
                            stateViewModel.apply(.selectNote(note))
                        }) {
                            Color.clear
                        }
                        .frame(maxWidth: .infinity,
                               maxHeight: .infinity)
                    )
                    .swipeActions(edge: .trailing,
                                  allowsFullSwipe: false) {
                        Button(role: .destructive, action: {
                            noteListViewModel.apply(.deleteNote(note))
                        }, label: {
                            Label("삭제", systemImage: "trash")
                        })
                        
                    }
                                  .contextMenu {
                                      Button(action: {
                                          noteListViewModel.apply(.deleteNote(note))
                                      }) {
                                          Label("삭제", systemImage: "trash")
                                      }
                                  }
                    
            }
                    
            
        }
        
#endif
    }
}
