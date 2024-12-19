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
    }
    private let dbManager = DBManager()
    var cancellables: Set<AnyCancellable> = []
    @Published var totalCost: Double = 0
    @Published var sheetType: AddTravelCostViewSheetType?
    
    
    func apply(_ intent: Intent) {
        switch intent {
        case .insertModelContext(let modelContext):
            dbManager.modelContext = modelContext
            
        case .showAddTravelCostView:
            sheetType = .add
            
        case .showEditTravelCostView:
            sheetType = .edit
        }
    }
}

enum AddTravelCostViewSheetType {
    case add
    case edit
}
