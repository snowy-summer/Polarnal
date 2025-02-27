//
//  TodoUseCaseProtocol.swift
//  Polarnal
//
//  Created by 최승범 on 2/27/25.
//

import Foundation

protocol TodoUseCaseProtocol {
    func addTodo(_ todo: TodoDB)
    func deleteTodo(_ todo: TodoDB)
    func deleteTodoFolder(_ todo: TodoFolderDB)
    func fetchTodoList(folderID: UUID) -> [TodoDB]
}
