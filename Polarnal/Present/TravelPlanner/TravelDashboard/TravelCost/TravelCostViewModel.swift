//
//  TravelCostViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/19/24.
//

import Foundation
import Combine
import SwiftData

final class TravelCostViewModel: ViewModelProtocol {
    enum Intent {
        case insertModelContext(ModelContext, UUID?)
        case showAddTravelCostView
        case showEditTravelCostView
        case deleteTravelCost(TravelCostDB)
        case fetchList
    }
    
    private let dbManager = DBManager()
    private var travelPlanID: UUID?
    var cancellables: Set<AnyCancellable> = []
    @Published var sheetType: AddTravelCostViewSheetType?
    
    
    @Published var totalCost: Double = 0
    @Published var costList: [TravelCostDB] = []
    
    func apply(_ intent: Intent) {
        switch intent {
        case .insertModelContext(let modelContext,
                                 let travelId):
            dbManager.modelContext = modelContext
            travelPlanID = travelId
            fetchCostLit()
            
        case .showAddTravelCostView:
            sheetType = .add
            
        case .showEditTravelCostView:
            sheetType = .edit
            
        case .deleteTravelCost(let travelCost):
            return
            
        case .fetchList:
            fetchCostLit()
        }
    }
}

extension TravelCostViewModel {
    
    private func fetchCostLit() {
        if dbManager.modelContext == nil, travelPlanID == nil {
            LogManager.log("modelContext가 없습니다")
            return
        }
        
        costList = dbManager.fetchItems(ofType: TravelCostDB.self).filter { cost in
            cost.travelPlanID == travelPlanID!
        }.sorted {
            $0.date < $1.date
        }
    }
}

enum AddTravelCostViewSheetType: Identifiable {
    
    case add
    case edit
    
    var id: String {
        switch self {
        case .add:
            return "add"
            
        case .edit:
            return "edit"
        }
    }
}
