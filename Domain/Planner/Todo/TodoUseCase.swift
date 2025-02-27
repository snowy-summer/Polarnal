//
//  TodoUseCase.swift
//  Polarnal
//
//  Created by 최승범 on 2/27/25.
//

import Foundation

final class TodoUseCase: TodoUseCaseProtocol {
    
    private let todoRepository: TodoRepositoryProtocol
    
    init(todoRepository: TodoRepositoryProtocol) {
        self.todoRepository = todoRepository
    }
    
    func deleteTodoFolder(_ todoFolder: TodoFolderDB) {
        todoRepository.deleteTodoFolder(todoFolder)
    }
    
    func addTodo(_ todo: TodoDB) {
        todoRepository.addTodo(todo)
    }
    
    func deleteTodo(_ todo: TodoDB) {
        todoRepository.deleteTodo(todo)
    }
    
    func fetchTodoList(folderID: UUID) -> [TodoDB] {
        todoRepository.fetchTodoList().filter { todo in
            if todo.folder == nil {
                return false
            }
            
            return todo.folder!.id == folderID
        }
    }
    
}
