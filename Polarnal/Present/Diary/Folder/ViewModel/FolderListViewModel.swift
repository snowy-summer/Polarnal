//
//  FolderListViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import Combine
import SwiftData

final class FolderListViewModel: ViewModelProtocol {
    
    enum Intent {
        case insertModelContext(ModelContext)
        case fetchFolderList
        case deleteFolder(Folder)
    }
    
    @Published var folderList: [Folder] = []

    private let dbManager = DBManager()
    var cancellables: Set<AnyCancellable> = []
    
    func apply(_ intent: Intent) {
        
        switch intent {
            // view 생성시 ModelContext주입
        case .insertModelContext(let modelContext):
            dbManager.modelContext = modelContext
            fetchFolderList()
            
        case .fetchFolderList:
            fetchFolderList()
            
        case .deleteFolder(let folder):
            deleteFolder(folder)
        }
    }
}

extension FolderListViewModel {
    
    func fetchFolderList() {
        folderList = dbManager.fetchItems(ofType: Folder.self)
        folderList.sort { $0.createAt < $1.createAt }
    }
    
    func deleteFolder(_ folder: Folder) {
        dbManager.deleteItem(folder)
    }
    
}
