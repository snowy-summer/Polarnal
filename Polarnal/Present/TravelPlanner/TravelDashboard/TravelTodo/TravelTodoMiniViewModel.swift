//
//  TravelTodoMiniViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/17/24.
//

import Foundation
import Combine
import SwiftData

final class TravelTodoMiniViewModel: ViewModelProtocol {
    
    enum Intent {
        case insertModelContext(ModelContext)
        case viewSetting
        case addTodo
        case deleteTodo(TravelTodoDB)
    }
    
    private let dbManager = DBManager()
    var cancellables: Set<AnyCancellable> = []
    let travelPlan: TravelPlanDB
    @Published var todoList: [TravelTodoDB]
    
    init(travel: TravelPlanDB) {
        self.travelPlan = travel
        self.todoList = dbManager.fetchItems(ofType: TravelTodoDB.self).filter { todo in
            todo.travelPlanID == travel.id
        }
    }
    
    func apply(_ intent: Intent) {
        
        switch intent {
        case .viewSetting:
            todoList = dbManager.fetchItems(ofType: TravelTodoDB.self).filter { todo in
                todo.travelPlanID == travelPlan.id
            }
            
        case .insertModelContext(let modelContext):
            dbManager.modelContext = modelContext
            
        case .addTodo:
            dbManager.addItem(TravelTodoDB(content: "", travelPlanID: travelPlan.id))
            todoList = dbManager.fetchItems(ofType: TravelTodoDB.self).filter { todo in
                todo.travelPlanID == travelPlan.id
            }
            
        case .deleteTodo(let todo):
            dbManager.deleteItem(todo)
            todoList = dbManager.fetchItems(ofType: TravelTodoDB.self).filter { todo in
                todo.travelPlanID == travelPlan.id
            }
        }
        
    }
}

