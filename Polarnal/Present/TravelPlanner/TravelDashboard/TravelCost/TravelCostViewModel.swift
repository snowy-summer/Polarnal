//
//  TravelCostViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/19/24.
//

import Foundation
import Combine
import SwiftData
import EnumHelper

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
    @Published var chartDataList: [CategorySum] = []
    
    init() {
        binding()
    }
    
    func apply(_ intent: Intent) {
        switch intent {
        case .insertModelContext(let modelContext,
                                 let travelId):
            dbManager.modelContext = modelContext
            travelPlanID = travelId
            fetchCostList()
            
        case .showAddTravelCostView:
            sheetType = .add
            
        case .showEditTravelCostView:
            sheetType = .edit
            
        case .deleteTravelCost(let travelCost):
            dbManager.deleteItem(travelCost)
            fetchCostList()
            
        case .fetchList:
            fetchCostList()
        }
    }
}

extension TravelCostViewModel {
    
    private func binding() {
        $costList
            .sink {[weak self] costList in
                guard let self else { return }
                totalCost = costList.reduce(0) { $0 + $1.spentCost }
                
                let categorySums = costList
                    .reduce(into: [String: Double]()) { result, item in
                        result[item.costType, default: 0] += item.spentCost
                    }
                
                var categorySumList = categorySums.map { CategorySum(category: TravelCostType(rawValue: $0.key) ?? .other ,
                                                                     totalCost: $0.value) }
                categorySumList.sort { $0.totalCost > $1.totalCost }
                chartDataList = categorySumList
            }
            .store(in: &cancellables)
    }
    
    private func fetchCostList() {
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

@IdentifiableEnum
enum AddTravelCostViewSheetType {
    case add
    case edit
}

struct CategorySum: Equatable {
    var category: TravelCostType
    var totalCost: Double
}
