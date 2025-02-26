//
//  CalendarUseCase.swift
//  Polarnal
//
//  Created by 최승범 on 2/26/25.
//

import Foundation

final class CalendarUseCase: CalendarUseCaseProtocol {
    
    func extractDate(currentDate: Date) -> [DateValue] {
        let calendar = Calendar.current
                var days = currentDate.getAllDates().compactMap { date -> DateValue in
                    let day = calendar.component(.day, from: date)
                    return DateValue(day: day, date: date)
                }
                
                let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
                for _ in 0 ..< firstWeekday - 1 {
                    days.insert(DateValue(day: -1, date: Date()), at: 0)
                }
                
                while days.count < 42 {
                    days.append(DateValue(day: -1, date: Date()))
                }
                
                return days
    }
    
    func updateDate(currentDate: Date,
                    byAddingMonths months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: currentDate) ?? currentDate
    }
    
}
