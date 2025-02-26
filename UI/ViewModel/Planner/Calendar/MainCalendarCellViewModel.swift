//
//  MainCalendarCellViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/13/24.
//

import SwiftUI
import SwiftData
import Combine

final class MainCalendarCellViewModel: ViewModelProtocol {
    
    private var calendarEventUseCase: CalendarEventUseCaseProtocol?
    
    var cancellables: Set<AnyCancellable> = []
    
    @Published var eventList: [EventDB] = []
    
    let dateValue: DateValue
    let isSunday: Bool
    let isSaturday: Bool
    let isEmptyView: Bool
    
    var isToday: Bool {
        if isEmptyView { return false }
        
        return calendarEventUseCase?.isToday(date: dateValue.date) ?? false
    }
    
    var color: Color {
        if isSunday {
            return Color.red
        } else if isSaturday {
            return Color.blue
        } else {
            return Color.normalText
        }
    }
    
    init(useCase: CalendarEventUseCaseProtocol? = nil,
         dateValue: DateValue,
         isSunday: Bool,
         isSaturday: Bool,
         isEmptyView: Bool) {
        self.calendarEventUseCase = useCase
        self.dateValue = dateValue
        self.isSunday = isSunday
        self.isSaturday = isSaturday
        self.isEmptyView = isEmptyView
    }
    
    enum Intent {
        case ingectDependencies(useCase: CalendarEventUseCaseProtocol)
    }
    
    func apply(_ intent: Intent) {
        switch intent {
        case .ingectDependencies(let useCase):
            calendarEventUseCase = useCase
            eventList = calendarEventUseCase!.eventRepository.fetchEvents(for: dateValue.date)
            
        }
    }
}
