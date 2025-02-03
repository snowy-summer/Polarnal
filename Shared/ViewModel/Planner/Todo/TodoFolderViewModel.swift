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
        case viewSetting
        case addTodo
        case deleteTodo(TodoDB)
    }
    
    private let dbManager = DBManager()
    var cancellables: Set<AnyCancellable> = []
    let todofolder: TodoFolderDB
    @Published var todoList: [TodoDB]
    
    init(folder: TodoFolderDB) {
        self.todofolder = folder
        self.todoList = dbManager.fetchItems(ofType: TodoDB.self).filter { todo in
            todo.folder.id == folder.id
        }
    }
    
    func apply(_ intent: Intent) {
        
        switch intent {
        case .viewSetting:
            todoList = dbManager.fetchItems(ofType: TodoDB.self).filter { todo in
                todo.folder.id == todofolder.id
            }
            
        case .insertModelContext(let modelContext):
            dbManager.modelContext = modelContext
            
        case .addTodo:
            dbManager.addItem(TodoDB(content: "", folder: todofolder))
            todoList = dbManager.fetchItems(ofType: TodoDB.self).filter { todo in
                    todo.folder.id == todofolder.id
                }
            
        case .deleteTodo(let todo):
            dbManager.deleteItem(todo)
            todoList = dbManager.fetchItems(ofType: TodoDB.self).filter { todo in
                todo.folder.id == todofolder.id
            }
        }
        
    }
}
