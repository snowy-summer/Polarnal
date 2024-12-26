//
//  TravelPlanDetailViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/26/24.
//

import Foundation
import Combine
import SwiftData

final class TravelPlanDetailViewModel: ViewModelProtocol {
    
    enum Intent {
        case insertModelContext(ModelContext, TravelPlanDB?)
        case deleteTravelPlanDetail(TravelPlanDetailDB)
        case selectNextDate
        case selectPreviousDate
        case addPlanDetail
        case fetchList
    }
    
    private let dbManager = DBManager()
    private var travelPlan: TravelPlanDB?
    var cancellables: Set<AnyCancellable> = []
    
    @Published var sheetType: AddTravelPlanDetailSheetType?
    @Published var selectedDate: Date?
    @Published var planList: [TravelPlanDetailDB] = []
    
    func apply(_ intent: Intent) {
        switch intent {
        case .insertModelContext(let modelContext,
                                 let travelplan):
            dbManager.modelContext = modelContext
            travelPlan = travelplan
            selectedDate = travelplan?.startDate
            fetchPlanList()
            
        case .addPlanDetail:
            addPlanDetail()
            fetchPlanList()
            
        case .deleteTravelPlanDetail(let planDetail):
            dbManager.deleteItem(planDetail)
            fetchPlanList()
            
        case .selectNextDate:
            print("다음 날")
            
        case .selectPreviousDate:
            print("이전 날")
            
        case .fetchList:
            fetchPlanList()
            
        }
    }
}

extension TravelPlanDetailViewModel {
    
    private func fetchPlanList() {
        if let travelPlan {
            planList = dbManager.fetchItems(ofType: TravelPlanDetailDB.self)
                .filter {
                    $0.travelPlanID == travelPlan.id
                    // 선택된 날짜의 것만 뽑아 오는거 추가 해야함, 정렬도
                }
        }
    }
    
    func lastCheck(plan: TravelPlanDetailDB) -> Bool {
        if !planList.isEmpty {
            return planList.last!.id == plan.id
        }
        
        return false
    }
    
    private func addPlanDetail() {
        if let selectedDate,
           let travelPlan {
            let planDetail = TravelPlanDetailDB(title: "",
                                                type: TravelCostType.other.rawValue,
                                                date: selectedDate,
                                                travelPlanID: travelPlan.id)
            dbManager.addItem(planDetail)
        } else {
            LogManager.log("PlanDetail 추가 실패")
        }
    }
    
}

enum AddTravelPlanDetailSheetType: Identifiable {
    
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
