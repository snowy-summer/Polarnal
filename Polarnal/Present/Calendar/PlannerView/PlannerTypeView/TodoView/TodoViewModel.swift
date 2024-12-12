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
        case showAddTodoFolderView
        case deleteTodoFolder(TodoFolderDB)
        case insertModelContext(ModelContext)
    }
    
    private let dbManager = DBManager()
    var cancellables: Set<AnyCancellable> = []
    
    func apply(_ intent: Intent) {
        switch intent {
        case .showAddTodoFolderView:
            return
            
        case .deleteTodoFolder(let todoFolderDB):
            return
            
        case .insertModelContext(let modelContext):
            dbManager.modelContext = modelContext
        }
    }
    
}
