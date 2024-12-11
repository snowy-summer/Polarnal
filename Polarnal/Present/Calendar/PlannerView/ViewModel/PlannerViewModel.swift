//
//  PlannerViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/10/24.
//

import Combine

final class PlannerViewModel: ViewModelProtocol {
    
    enum Intent {
        //일정 카테고리 추가 ex) 개인, 회사
        case showAddEventCategoryView
        case showEditEventCategoryView
        
        //일정 추가 ex) 00월 00일 생일
        case showAddEventView
        
        case showAddDDay
        
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
    
    enum DDaySheetType: Identifiable {
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
    @Published var eventCategoryType: EventCategoryType?
    @Published var eventSheetType: EventCategoryType?
    @Published var dDaySheetType: DDaySheetType?
    
    var cancellables: Set<AnyCancellable> = []
    
    func apply(_ intent: Intent) {
        switch intent {
        case .showAddEventCategoryView:
            eventCategoryType = .add
            
        case .showEditEventCategoryView:
            eventCategoryType = .edit
            
        case .showAddEventView:
            eventSheetType = .add
            
        case .showAddDDay:
            dDaySheetType = .add
            
        case .showDDayView:
            showedViewType = .dday
            
        }
    }
    
}

