//
//  AddTravelPlanViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/16/24.
//
#if os(iOS)
import SwiftUI
import Combine
import SwiftData

final class AddTravelPlanViewModel: ViewModelProtocol {
    
    @Published var travelTitle: String
    @Published var destinationCountry: String
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    
    private var travelPlan: TravelPlanDB?
    
    init(travelPlanData: TravelPlanDB?) {
        if let travelPlanData {
            travelTitle = travelPlanData.title
            destinationCountry = travelPlanData.country
            startDate = travelPlanData.startDate
            endDate = travelPlanData.endDate
        } else {
            travelTitle = ""
            destinationCountry = ""
        }
    }
    
    enum Intent {
        case saveTravel
        case insertModelContext(ModelContext)
    }
    
    private let dbManager = DBManager()
    var cancellables = Set<AnyCancellable>()
    
    func apply(_ intent: Intent) {
        switch intent {
        case .saveTravel:
            travelPlan == nil ? saveTravel() : editSaveTravel()
            
        case .insertModelContext(let modelContext):
            dbManager.modelContext = modelContext
            
        }
    }
}

extension AddTravelPlanViewModel {
    
    private func saveTravel() {
        let travel = TravelPlanDB(title: travelTitle,
                                  country: destinationCountry,
                                  startDate: startDate,
                                  endDate: endDate)
        dbManager.addItem(travel)
    }
    
    private func editSaveTravel() {
        travelPlan?.title = travelTitle
        travelPlan?.country = destinationCountry
        travelPlan?.startDate = startDate
        travelPlan?.endDate = endDate
        if let travelPlan {
            dbManager.addItem(travelPlan)
        } else {
            LogManager.log("Travel plan 수정 실패")
        }
    }
    
}
#endif
