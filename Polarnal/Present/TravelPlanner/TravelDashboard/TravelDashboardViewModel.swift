//
//  TravelDashboardViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/16/24.
//

import Foundation
import Combine
import SwiftData

final class TravelDashboardViewModel: ViewModelProtocol {
    
    enum Intent {
        case insertModelContext(ModelContext)
        
        case selectTravel(TravelPlanDB)
        case showAddTravelView

        // Todo
        case addTodo
        case deleteTodo(TravelTodoDB)
        
        // Cost
        
        // Ticket
    }
    
    private let dbManager = DBManager()
    var cancellables: Set<AnyCancellable> = []
    
    @Published var selectedTravel: TravelPlanDB?
    @Published var sheetType: TravelPlanSheetType?
    
    func apply(_ intent: Intent) {
        switch intent {
        case .insertModelContext(let modelContext):
            dbManager.modelContext = modelContext
            
        case .selectTravel(let travelPlanDB):
            selectedTravel = travelPlanDB
            
        case .showAddTravelView:
            sheetType = .addTravelPlan
            
        case .addTodo:
            addTodo()
            
        case .deleteTodo(let todo):
            deleteTodo(todo: todo)
        }
    }
    
}

extension TravelDashboardViewModel {
    
    private func addTodo() {
        if dbManager.modelContext == nil { 
            LogManager.log("ModelContext가 없습니다")
            return
        }
        let todo = TravelTodoDB(content: "")
        selectedTravel?.todoList.append(todo)
        
        if let selectedTravel {
            dbManager.addItem(selectedTravel)
        } else {
            LogManager.log("선택된 Travel이 없습니다")
        }
        
    }
    
    private func deleteTodo(todo: TravelTodoDB) {
        if dbManager.modelContext == nil {
            LogManager.log("ModelContext가 없습니다")
            return
        }
        dbManager.deleteItem(todo)
    }
    
}

enum TravelPlanSheetType: CaseIterable, Identifiable {
    case addTravelPlan
    case editTravelPlan
    
    var id: String {
        switch self {
        case .addTravelPlan:
            return "addTravelPlan"
            
        case .editTravelPlan:
            return "editTravelPlan"
        }
    }
}
