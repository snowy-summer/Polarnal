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
        
    }
    
    private let dbManager = DBManager()
    var cancellables: Set<AnyCancellable> = []
    
    @Published var selectedTravel: TravelPlanDB?
    @Published var todoList: [TravelTodoDB] = []
    @Published var sheetType: TravelPlanSheetType?
    
    init() {
        binding()
    }
    
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
            updateTodoList()
            
        case .deleteTodo(let todo):
            deleteTodo(todo: todo)
            updateTodoList()
        }
    }
    
    func binding() {
        $selectedTravel
            .compactMap{ $0 }
            .sink { [weak self] travel in
                guard let self = self else { return }
                todoList = travel.todoList
            }
            .store(in: &cancellables)
    }
    
}

extension TravelDashboardViewModel {
    
    private func updateTodoList() {
        todoList = dbManager.fetchItems(ofType: TravelTodoDB.self).filter {
            if let selectedTravel {
                return $0.travelPlanID == selectedTravel.id
            } else {
                return false
            }
        }
    }
    
    private func addTodo() {
        if dbManager.modelContext == nil {
            LogManager.log("ModelContext가 없습니다")
            return
        }
        
        if let selectedTravel {
            let todo = TravelTodoDB(content: "",
                                    travelPlanID: selectedTravel.id)
            selectedTravel.todoList.append(todo)
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
