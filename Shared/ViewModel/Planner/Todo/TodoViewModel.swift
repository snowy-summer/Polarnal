//
//  TodoViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/12/24.
//

import Foundation
import Combine
import SwiftData

final class TodoViewModel: ViewModelProtocol {
    
    enum Intent {
        case deleteTodoFolder(TodoFolderDB)
        case insertModelContext(ModelContext)
        case selectFolder(TodoFolderDB)
        case clearSelectedFolder
    }
    
    private let dbManager = DBManager()
    var cancellables: Set<AnyCancellable> = []
    @Published var selectedFolder: TodoFolderDB?
    
    func apply(_ intent: Intent) {
        switch intent {
        case .deleteTodoFolder(let todoFolderDB):
            dbManager.deleteItem(todoFolderDB)
            
        case .insertModelContext(let modelContext):
            dbManager.modelContext = modelContext
        
        case .selectFolder(let folder):
            selectedFolder = folder
            
        case.clearSelectedFolder:
            selectedFolder = nil
        }
    }
    
}
