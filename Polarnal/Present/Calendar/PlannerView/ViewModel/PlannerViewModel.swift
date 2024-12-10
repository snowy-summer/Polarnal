//
//  PlannerViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/10/24.
//

import Combine

final class PlannerViewModel: ViewModelProtocol {
    
    enum Intent {
        case showAddEventCategoryView
        case showEditEventCategoryView
        case showDDayView
    }
    
    enum EventCategoryType: Identifiable {
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
    
    enum PlannerViewType {
        case calendar
        case dday
    }
    
    @Published var showedViewType: PlannerViewType = .calendar
    @Published var sheetType: EventCategoryType?
    var cancellables: Set<AnyCancellable> = []
    
    func apply(_ intent: Intent) {
        switch intent {
        case .showAddEventCategoryView:
            sheetType = .add
            
        case .showEditEventCategoryView:
            sheetType = .edit
            
        case .showDDayView:
            showedViewType = .dday
            
        }
    }
    
}

