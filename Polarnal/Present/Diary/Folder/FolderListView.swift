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
    
    init(stateViewModel: DiaryStateViewModel,
         uiViewModel: DiaryUIViewModel,
         folderListViewModel: FolderListViewModel) {
        self.stateViewModel = stateViewModel
        self.uiViewModel = uiViewModel
        self.folderListViewModel = folderListViewModel
    }
    
    var body: some View {
        List {
            ForEach(folderListViewModel.folderList) { folder in
                
                FolderListCell(folder: folder)
                    .background(
                           Button(action: {
                               stateViewModel.apply(.selectFolder(folder))
                           }) {
                               Color.clear
                           }
                           .frame(maxWidth: .infinity,
                                  maxHeight: .infinity)
                       )
                    .contextMenu {
                        Button(action: {
                            folderListViewModel.apply(.deleteFolder(folder))
                        }) {
                            Label("삭제", systemImage: "trash")
                        }
                        Button(action: {
                            uiViewModel.apply(.showEditFolderView(folder))
                        }) {
                            Label("편집", systemImage: "pencil")
                        }
                    }
            }
        }
    }
    
}
