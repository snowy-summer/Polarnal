//
//  DateManager.swift
//  Polarnal
//
//  Created by 최승범 on 12/9/24.
//

import Foundation

final class DateManager {
    
    static let shared = DateManager()
    private init() { }
    
    private let dateFormatter = DateFormatter()
    
    func getYearAndMonthString(currentDate: Date) -> [String] {
        
        dateFormatter.dateFormat = "YYYY MM dd"
        dateFormatter.locale = Locale(identifier: "ko_kr")
        
        let date = dateFormatter.string(from: currentDate)
        let yearMonthDay = date.components(separatedBy: " ")
        
        return yearMonthDay
    }
    
    func getDateString(date: Date) -> String {
        dateFormatter.dateFormat = "YYYY.MM.dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func getDateString(format: String, date: Date) -> String {
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func calculateDDay(startDay: Date,
                       goalDay: Date) -> String {
        let calendar = Calendar.current
        let today = startDay
        let target = calendar.startOfDay(for: goalDay)
        
        let components = calendar.dateComponents([.day],
                                                 from: today,
                                                 to: target)
        
        guard let dayDifference = components.day else {
            LogManager.log("D-day 계산 불가")
            return "D-day 계산 불가"
        }
        
        if dayDifference == 0 {
            return "D-Day"
        } else if dayDifference > 0 {
            return "D-\(dayDifference + 1)"
        } else {
            return "D+\(-dayDifference)"
        }
    }
    
    func calculateDPlus(startDay: Date) -> String {
        let calendar = Calendar.current
        let today = Date()
        
        let components = calendar.dateComponents([.day],
                                                 from: today,
                                                 to: startDay)
        
        guard let dayDifference = components.day else {
            LogManager.log("D+ 계산 불가")
            return "D+ 계산 불가"
        }
        
        return "D+\(-(dayDifference - 1))"
    }
    
}
