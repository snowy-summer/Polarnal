//
//  FolderListView.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI

struct FolderListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var stateViewModel: DiaryStateViewModel
    @ObservedObject var uiViewModel: DiaryUIViewModel
    @ObservedObject var folderListViewModel: FolderListViewModel
    
    var body: some View {
        List {
            ForEach(folderListViewModel.folderList) { folder in
                
                FolderListCell(folder: folder)
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
                    .onTapGesture {
                        stateViewModel.apply(.selectFolder(folder))
                    }
            }
        }
    }
    
}
