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
    @StateObject var stateViewModel: DiaryStateViewModel
    @StateObject var uiViewModel: DiaryUIViewModel
    @StateObject var folderViewModel: FolderListViewModel
    @StateObject var noteViewModel: NoteListViewModel
    @ObservedObject var sideTabBarViewModel: SideTabBarViewModel
    
    var body: some View {
        NavigationSplitView {
            HStack {
                SideTabBarView(viewModel: sideTabBarViewModel)
                    .frame(width: 80)
                FolderListView(stateViewModel: stateViewModel,
                               uiViewModel: uiViewModel,
                               folderListViewModel: folderViewModel)
            }
            
            Divider()
            
            Button(action: {
                uiViewModel.apply(.showAddFolderView)
            }) {
                Label("새로운 폴더", systemImage: "plus.circle")
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom)
            
        } content: {
         NoteListView(stateViewModel: stateViewModel,
                      noteListViewModel: noteViewModel)
         .navigationTitle(stateViewModel.selectedFolder?.title ?? "")
        } detail: {
            
            Group {
                if let note = stateViewModel.selectedNote {
                    NoteContentView(noteContentViewModel: noteViewModel)
                } else {
                    Text("노트를 선택 해주세요")
                }
            }
            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
                   
//                    Button {
//                        uiViewModel.apply(.showPhotoPicker)
//                    } label: {
//                        Image(systemName: "photo")
//                    }
//                    Button("Test Button") {
//                               print("Button pressed")
//                           }
//                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        stateViewModel.apply(.addNote)
                    }) {
                        Image(systemName: "plus")
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
        }
    }
    
}
