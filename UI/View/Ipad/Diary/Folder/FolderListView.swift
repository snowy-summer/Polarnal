//
//  FolderListView.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI

struct FolderListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @ObservedObject private var stateViewModel: DiaryStateViewModel
    @ObservedObject private var uiViewModel: DiaryUIViewModel
    @ObservedObject private var folderListViewModel: FolderListViewModel
    private var noteListViewModel: NoteListViewModel
    
    init(stateViewModel: DiaryStateViewModel,
         uiViewModel: DiaryUIViewModel,
         folderListViewModel: FolderListViewModel,
         noteListViewModel: NoteListViewModel) {
        self.stateViewModel = stateViewModel
        self.uiViewModel = uiViewModel
        self.folderListViewModel = folderListViewModel
        self.noteListViewModel = noteListViewModel
    }
    
    var body: some View {
#if os(macOS)
        List {
            ForEach(folderListViewModel.folderList) { folder in
                FolderListCell(folder: folder,
                               isMac: true)
                .contentShape(Rectangle())
                .onTapGesture {
                    stateViewModel.apply(.selectFolder(folder))
                    noteListViewModel.apply(.selectFolder(folder))
                }
                .contextMenu {
                    Button(role: .destructive, action: {
                        folderListViewModel.apply(.deleteFolder(folder))
                    }, label: {
                        Label("삭제", systemImage: "trash")
                    })
                
                    Button(action: {
                        uiViewModel.apply(.showEditFolderView(folder))
                    }) {
                        Label("편집", systemImage: "pencil")
                    }
                }
                    
            }
        }
        .scrollContentBackground(.hidden)
        #else
        List {
            ForEach(folderListViewModel.folderList) { folder in
                
                FolderListCell(folder: folder)
                    .background(
                           Button(action: {
                               stateViewModel.apply(.selectFolder(folder))
                               noteListViewModel.apply(.selectFolder(folder))
                           }) {
                               Color.clear
                           }
                           .frame(maxWidth: .infinity,
                                  maxHeight: .infinity)
                       )
                    .swipeActions(edge: .trailing,
                                  allowsFullSwipe: false) {
                        Button(role: .destructive, action: {
                            folderListViewModel.apply(.deleteFolder(folder))
                        }, label: {
                            Label("삭제", systemImage: "trash")
                        })
                        
                        Button(action: {
                            // TODO: - 편집 추가
                        }, label: {
                            Label("편집", systemImage: "pencil")
                        })
                    }
                    .contextMenu {
                        Button(role: .destructive, action: {
                            folderListViewModel.apply(.deleteFolder(folder))
                        }, label: {
                            Label("삭제", systemImage: "trash")
                        })
                    
                        Button(action: {
                            uiViewModel.apply(.showEditFolderView(folder))
                        }) {
                            Label("편집", systemImage: "pencil")
                        }
                    }
            }
        }
        .scrollContentBackground(.hidden)
#endif
        
    }
    
}
