//
//  TodoContentCellViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/12/24.
//

import Foundation
import SwiftData
import Combine

final class TodoContentCellViewModel: ViewModelProtocol {
    
    enum Intent {
        case ingectDependencies(useCase: TodoUseCaseProtocol)
        case todoDoneToggle
    }
    
    @Published var todo: TodoDB
    @Published var todoContent: String
    
    private var todoUseCase: TodoUseCaseProtocol?
    var cancellables: Set<AnyCancellable> = []
    
    init(todo: TodoDB) {
        self.todo = todo
        self.todoContent = todo.content
        binding()
    }
    
    func apply(_ intent: Intent) {
        switch intent {
        case .ingectDependencies(let useCase):
            todoUseCase = useCase
            
        case .todoDoneToggle:
            todo.isDone.toggle()
            todoUseCase?.addTodo(todo)
        }
    }
    
    func binding() {
        $todoContent
            .debounce(for: .seconds(0.5),
                              scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self else { return }
                if text != todo.content {
                    todo.content = text
                    todoUseCase?.addTodo(todo)
                }
            }
            .store(in: &cancellables)
    }
}
