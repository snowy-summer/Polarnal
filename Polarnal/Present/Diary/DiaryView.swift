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
    
    var body: some View {
        NavigationSplitView {
            FolderListView(stateViewModel: stateViewModel,
                           uiViewModel: uiViewModel,
                           folderListViewModel: folderViewModel)
            
            Divider()
            
            Button(action: {
                uiViewModel.apply(.showAddFolderView)
            }) {
                Label("새로운 폴더", systemImage: "plus.circle")
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom)
            
        } content: {
         
        } detail: {
            
//            Text("1")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        uiViewModel.apply(.showPhotoPicker)
//                    }) {
//                        Image(systemName: "photo")
//                    }
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        stateViewModel.apply(.addNote)
//                    }) {
//                        Image(systemName: "plus")
//                    }
//                }
//            }
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
