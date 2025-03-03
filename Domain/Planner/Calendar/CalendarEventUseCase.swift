//
//  CalendarEventUseCase.swift
//  Polarnal
//
//  Created by 최승범 on 2/26/25.
//

import Foundation

final class CalendarEventUseCase: CalendarEventUseCaseProtocol {
    
    private let dateManager = DateManager.shared
    private let eventRepository: EventRepositoryProtocol
    
    init(eventRepository: EventRepositoryProtocol) {
        self.eventRepository = eventRepository
    }
    
    func isToday(date: Date) -> Bool {
        dateManager.getYearAndMonthString(currentDate: date) == dateManager.getYearAndMonthString(currentDate: Date())
    }
    
    func fetchEvents(for date: Date) -> [EventDB] {
        let allEventList = eventRepository.fetchEvents()
        return allEventList.filter {
            dateManager.getDateString(date: date) == dateManager.getDateString(date: $0.date)
        }.sorted {
            guard let categoryA = $0.category, let categoryB = $1.category else {
                return $0.category != nil
            }
            return categoryA.title < categoryB.title
        }
    }
    
    func deleteEvent(_ event: EventDB) {
        eventRepository.deleteEvent(event)
    }
    
}
