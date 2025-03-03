//
//  CalendarUseCaseProtocol.swift
//  Polarnal
//
//  Created by 최승범 on 2/26/25.
//

import Foundation

// 날짜 관련 처리
protocol CalendarDateUseCaseProtocol {
    func extractDate(currentDate: Date) -> [DateValue]
    func updateDate(currentDate: Date,
                    byAddingMonths months: Int) -> Date
}

//Event 관련 처리
protocol CalendarEventUseCaseProtocol {
    func fetchEvents(for date: Date) -> [EventDB]
    func isToday(date: Date) -> Bool
    func deleteEvent(_ event: EventDB)
}
