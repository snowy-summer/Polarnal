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
        case insertModelContext(ModelContext)
        case showAddTravelCostView
        case showEditTravelCostView
        case deleteTravelCost(TravelCostDB)
    }
    
    private let dbManager = DBManager()
    var cancellables: Set<AnyCancellable> = []
    @Published var sheetType: AddTravelCostViewSheetType?
    
    
    @Published var totalCost: Double = 0
    @Published var costList: [TravelCostDB] = []
    
    
    
    func apply(_ intent: Intent) {
        switch intent {
        case .insertModelContext(let modelContext):
            dbManager.modelContext = modelContext
            
        case .showAddTravelCostView:
            sheetType = .add
            
        case .showEditTravelCostView:
            sheetType = .edit
            
        case .deleteTravelCost(let travelCost):
            return
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
