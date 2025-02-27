//
//  TodoRepository.swift
//  Polarnal
//
//  Created by 최승범 on 2/27/25.
//

import Foundation
import SwiftData

final class TodoRepository: TodoRepositoryProtocol {
    
    private let dbManager: DBManager
    private let modelContext: ModelContext
    
    init(dbManager: DBManager = DBManager(), modelContext: ModelContext) {
        self.dbManager = dbManager
        self.modelContext = modelContext
        self.dbManager.modelContext = modelContext
    }
    
    func deleteTodoFolder(_ todoFolder: TodoFolderDB) {
        dbManager.deleteItem(todoFolder)
    }
    
    func addTodo(_ todo: TodoDB) {
        dbManager.addItem(todo)
    }
    
    func deleteTodo(_ todo: TodoDB) {
        dbManager.deleteItem(todo)
    }
    
    func fetchTodoList() -> [TodoDB] {
        return dbManager.fetchItems(ofType: TodoDB.self)
    }
    
}
