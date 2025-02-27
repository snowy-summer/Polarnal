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
        case ingectDependencies(useCase: TodoUseCaseProtocol)
        case viewSetting
        case addTodo
        case deleteTodo(TodoDB)
    }
    
    private var todoUseCase: TodoUseCaseProtocol?
    var cancellables: Set<AnyCancellable> = []
    let todofolder: TodoFolderDB
    @Published var todoList: [TodoDB]
    
    init(folder: TodoFolderDB) {
        self.todofolder = folder
        self.todoList = todoUseCase?.fetchTodoList(folderID: folder.id) ?? []
    }
    
    func apply(_ intent: Intent) {
        
        switch intent {
        case .viewSetting:
            todoList = todoUseCase?.fetchTodoList(folderID: todofolder.id) ?? []
            
        case .ingectDependencies(let useCase):
            todoUseCase = useCase
            
        case .addTodo:
            todoUseCase?.addTodo(TodoDB(content: "", folder: todofolder))
            todoList = todoUseCase?.fetchTodoList(folderID: todofolder.id) ?? []
            
        case .deleteTodo(let todo):
            todoUseCase?.deleteTodo(todo)
            todoList = todoUseCase?.fetchTodoList(folderID: todofolder.id) ?? []
        }
        
    }
}
