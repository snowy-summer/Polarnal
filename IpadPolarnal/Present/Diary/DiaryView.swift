//
//  DiaryView.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI
import Combine

struct DiaryView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var stateViewModel: DiaryStateViewModel = DiaryStateViewModel()
    @StateObject var uiViewModel: DiaryUIViewModel = DiaryUIViewModel()
    @StateObject var folderViewModel: FolderListViewModel = FolderListViewModel()
    @StateObject var noteViewModel: NoteListViewModel = NoteListViewModel()
    @ObservedObject var sideTabBarViewModel: SideTabBarViewModel
    
    private let newFolderTitle: LocalizedStringKey = "New Folder"
    
    var body: some View {
        NavigationSplitView {
            HStack {
                SideTabBarView(viewModel: sideTabBarViewModel)
                    .frame(width: 80)
                FolderListView(stateViewModel: stateViewModel,
                               uiViewModel: uiViewModel,
                               folderListViewModel: folderViewModel,
                               noteListViewModel: noteViewModel)
            }
            
            Divider()
            
            Button(action: {
                uiViewModel.apply(.showAddFolderView)
            }) {
                Label(newFolderTitle, systemImage: "plus.circle")
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom)
            
        } content: {
         NoteListView(stateViewModel: stateViewModel,
                      noteListViewModel: noteViewModel)
         .navigationTitle(stateViewModel.selectedFolder?.title ?? "")
        } detail: {
            
            Group {
                if let _ = stateViewModel.selectedNote {
                    NoteContentView(noteContentViewModel: noteViewModel)
                } else {
                    Text("노트를 선택 해주세요")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        noteViewModel.apply(.addNote)
                    }) {
                        Image(systemName: "plus")
                            .tint(Color.normalText)
                    }
                }
            }
            
        }
        
        .sheet(item: $uiViewModel.sheetType, onDismiss: {
            folderViewModel.apply(.fetchFolderList)
        }) { type in
            NavigationStack {
                switch type {
                case .addFolder:
                    AddFolderView(folder: nil)
                    
                case .editFolder(let folder):
                    AddFolderView(folder: folder)
                    
                default:
                    EmptyView()
                }
            }
        }
        .onAppear {
            folderViewModel.apply(.insertModelContext(modelContext))
            noteViewModel.apply(.insertModelContext(modelContext))
        }
    }
    
}
