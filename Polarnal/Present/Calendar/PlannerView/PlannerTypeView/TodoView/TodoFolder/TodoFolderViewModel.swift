//
//  TodoFolderViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/12/24.
//

import Foundation
import SwiftData
import Combine

final class TodoFolderCellViewModel: ViewModelProtocol {
    
    enum Intent {
        case insertModelContext(ModelContext)
        case addTodo
        case deleteTodo(TodoDB)
    }
    
    private let dbManager = DBManager()
    var cancellables: Set<AnyCancellable> = []
    let todofolder: TodoFolderDB
    
    init(folder: TodoFolderDB) {
        self.todofolder = folder
    }
    
    func apply(_ intent: Intent) {
        
        switch intent {
        case .insertModelContext(let modelContext):
            dbManager.modelContext = modelContext
            
        case .addTodo:
            dbManager.addItem(TodoDB(content: "", folder: todofolder))
            return
            
        case .deleteTodo(let todo):
            dbManager.deleteItem(todo)
        }
        
    }
}
