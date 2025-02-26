//
//  CalendarEventUseCase.swift
//  Polarnal
//
//  Created by 최승범 on 2/26/25.
//

import Foundation

final class CalendarEventUseCase: CalendarEventUseCaseProtocol {
    
    private let dateManager = DateManager.shared
    let eventRepository: EventRepositoryProtocol
    
    init(eventRepository: EventRepositoryProtocol) {
        self.eventRepository = eventRepository
    }
    
    func isToday(date: Date) -> Bool {
        dateManager.getYearAndMonthString(currentDate: date) == dateManager.getYearAndMonthString(currentDate: Date())
    }
    
    
}
