//
//  TodoViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/12/24.
//

import Foundation
import Combine

final class TodoViewModel: ViewModelProtocol {
    
    enum Intent {
        case deleteTodoFolder(TodoFolderDB)
        case ingectDependencies(useCase: TodoUseCaseProtocol)
        case selectFolder(TodoFolderDB)
        case clearSelectedFolder
    }
    
    private var todoUseCase: TodoUseCaseProtocol?
    
    var cancellables: Set<AnyCancellable> = []
    @Published var selectedFolder: TodoFolderDB?
    
    
    func apply(_ intent: Intent) {
        switch intent {
        case .deleteTodoFolder(let todoFolderDB):
            todoUseCase?.deleteTodoFolder(todoFolderDB)
            
        case .ingectDependencies(let useCase):
            todoUseCase = useCase
        
        case .selectFolder(let folder):
            selectedFolder = folder
            
        case.clearSelectedFolder:
            selectedFolder = nil
        }
    }
    
}

