//
//  ExpendedTodoCellViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/12/24.
//

import Foundation
import SwiftData
import Combine

final class ExpandedTodoCellViewModel: ViewModelProtocol {
    
    enum Intent {
        case insertModelContext(ModelContext)
        case todoDoneToggle
    }
    
    @Published var todo: TodoDB
    @Published var todoContent: String
    
    private let dbManager = DBManager()
    var cancellables: Set<AnyCancellable> = []
    
    init(todo: TodoDB) {
        self.todo = todo
        self.todoContent = todo.content
        binding()
    }
    
    func apply(_ intent: Intent) {
        switch intent {
        case .insertModelContext(let modelContext):
            dbManager.modelContext = modelContext
            
        case .todoDoneToggle:
            todo.isDone.toggle()
            dbManager.addItem(todo)
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
                    dbManager.addItem(todo)
                }
            }
            .store(in: &cancellables)
    }
}
