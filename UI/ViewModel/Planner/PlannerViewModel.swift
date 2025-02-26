//
//  PlannerViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/10/24.
//

import Combine
import EnumHelper

final class PlannerViewModel: ViewModelProtocol {
    
    enum Intent {
        //일정 카테고리 추가 ex) 개인, 회사
        case showAddEventCategoryView
        case showEditEventCategoryView
        
        //일정 추가 ex) 00월 00일 생일
        case showAddEventView
        
        case showAddTodoFolder
        case showAddDDay
        case showAddRoutine
        
        case showCalendarView
        case showTodoView
        case showDDayView
        case showRoutineView
    }
    
    enum PlannerViewType {
        case calendar
        case dday
        case todo
        case routine
    }
    
    @Published var showedViewType: PlannerViewType = .calendar
    @Published var eventCategoryType: EventCategoryType?
    @Published var eventSheetType: EventCategoryType?
    @Published var todoSheetType: TodoSheetType?
    @Published var dDaySheetType: DDaySheetType?
    @Published var routineSheetType: RoutineSheetType?
    
    var cancellables: Set<AnyCancellable> = []
    
    func apply(_ intent: Intent) {
        switch intent {
        case .showAddEventCategoryView:
            eventCategoryType = .add
            
        case .showEditEventCategoryView:
            eventCategoryType = .edit
            
        case .showAddEventView:
            eventSheetType = .add
            
        case .showAddTodoFolder:
            todoSheetType = .add
            
        case .showAddDDay:
            dDaySheetType = .add
            
        case .showAddRoutine:
            routineSheetType = .add
            
        case .showCalendarView:
            showedViewType = .calendar
            
        case .showDDayView:
            showedViewType = .dday
            
        case .showTodoView:
            showedViewType = .todo
            
        case .showRoutineView:
            showedViewType = .routine
        }
    }
    
}

@IdentifiableEnum
enum EventCategoryType {
    case add
    case edit
}

@IdentifiableEnum
enum DDaySheetType {
    case add
    case edit
}

@IdentifiableEnum
enum TodoSheetType {
    case add
    case edit
}

@IdentifiableEnum
enum RoutineSheetType {
    case add
    case edit
}
