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
    
    var body: some View {
        NavigationSplitView {
            FolderListView(stateViewModel: stateViewModel,
                           uiViewModel: uiViewModel)
            
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
            Group {
               
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        uiViewModel.apply(.showPhotoPicker)
                    }) {
                        Image(systemName: "photo")
                    }
                }
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
            stateViewModel.fetchFolders()
        }) { type in
            NavigationStack {
                switch type {
                case .addFolder:
                    AddFolderView(folder: nil)
                    
                case .editFolder(let folder):
                    AddFolderView(folder: folder)
                    
                case .photo:
                    PhotoPicker(selectedImage: $stateViewModel.selectedImage)
                }
            }
        }
    }
    
}
