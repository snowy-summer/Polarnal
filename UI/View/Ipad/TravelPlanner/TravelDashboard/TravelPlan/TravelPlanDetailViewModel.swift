//
//  TravelPlanDetailViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/26/24.
//
#if os(iOS)
import Foundation
import Combine
import SwiftData
import EnumHelper

final class TravelPlanDetailViewModel: ViewModelProtocol {
    
    enum Intent {
        case insertModelContext(ModelContext, TravelPlanDB?)
        case deleteTravelPlanDetail
        case selectNextDate
        case selectPreviousDate
        case fetchList
        
        case addPlanDetail
        case selectPlanDetail(TravelPlanDetailDB)
        case selectPlanDetailType(TravelCostType)
        
    }
    
    private let dbManager = DBManager()
    private let dateManager = DateManager.shared
    private var travelPlan: TravelPlanDB?
    var cancellables: Set<AnyCancellable> = []
    
    @Published var sheetType: AddTravelPlanDetailSheetType?
    @Published var selectedDay: Date?
    @Published var planList: [TravelPlanDetailDB] = []
    @Published var selectedPlan: TravelPlanDetailDB?
    
    @Published var planTitle: String = ""
    @Published var selectedPlanType: TravelCostType = .other
    @Published var planDate: Date = Date()
    
    init() {
        binding()
    }
    
    func apply(_ intent: Intent) {
        switch intent {
        case .insertModelContext(let modelContext,
                                 let travelplan):
            dbManager.modelContext = modelContext
            travelPlan = travelplan
            selectedDay = travelplan?.startDate
            fetchPlanList()
            if let plan = planList.first {
                apply(.selectPlanDetail(plan))
            }
            
        case .addPlanDetail:
            addPlanDetail()
            fetchPlanList()
            
        case .deleteTravelPlanDetail:
            if let selectedPlan  {
                dbManager.deleteItem(selectedPlan)
                fetchPlanList()
                if let plan = planList.first {
                    apply(.selectPlanDetail(plan))
                }
            }
            
        case .selectNextDate:
            if let currentDay = selectedDay {
                selectedDay = Calendar.current.date(byAdding: .day,
                                                    value: 1,
                                                    to: currentDay)
            }
            fetchPlanList()
            
        case .selectPreviousDate:
            
            if let currentDay = selectedDay {
                selectedDay = Calendar.current.date(byAdding: .day,
                                                    value: -1,
                                                    to: currentDay)
            }
            fetchPlanList()
            
        case .fetchList:
            fetchPlanList()
            
        case .selectPlanDetail(let planDetail):
            selectedPlan = planDetail
            planTitle = planDetail.title
            selectedPlanType = TravelCostType(rawValue: planDetail.type) ?? .other
            planDate = planDetail.date
            
        case .selectPlanDetailType(let type):
            selectedPlanType = type
            savePlan()
            
        }
    }
}

extension TravelPlanDetailViewModel {
    
    private func binding() {
        $planTitle
            .debounce(for: .seconds(1),
                      scheduler: DispatchQueue.main)
            .sink { [weak self] title in
                guard let self else { return }
                savePlan()
            }
            .store(in: &cancellables)
        
        $planDate
            .debounce(for: .seconds(1),
                      scheduler: DispatchQueue.main)
            .sink { [weak self] title in
                guard let self else { return }
                savePlan()
            }
            .store(in: &cancellables)
        
    }
    
    private func fetchPlanList() {
        if let travelPlan {
            planList = dbManager.fetchItems(ofType: TravelPlanDetailDB.self)
                .filter {
                    // 선택된 날짜의 것만 뽑아 오는거 추가 해야함, 정렬도
                    if let selectedDay {
                        return $0.travelPlanID == travelPlan.id
                        && dateManager.getDateString(date: $0.date) == dateManager.getDateString(date: selectedDay)
                    } else {
                        return false
                    }
                    
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
        if let selectedDay,
           let travelPlan {
            let planDetail = TravelPlanDetailDB(title: "",
                                                type: TravelCostType.other.rawValue,
                                                date: selectedDay,
                                                travelPlanID: travelPlan.id)
            dbManager.addItem(planDetail)
        } else {
            LogManager.log("PlanDetail 추가 실패")
        }
    }
    
    private func savePlan() {
        if selectedPlan != nil {
            selectedPlan?.date = planDate
            selectedPlan?.title = planTitle
            selectedPlan?.type = selectedPlanType.rawValue
            
            dbManager.addItem(selectedPlan!)
        }
    }
    
}

@IdentifiableEnum
enum AddTravelPlanDetailSheetType {
    case add
    case edit
}
#endif
