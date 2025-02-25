//
//  Date+Extension.swift
//  Polarnal
//
//  Created by 최승범 on 12/9/24.
//

import Foundation

extension Date {
    
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        // 현재 월의 첫 날(startDate) 구하기 -> 일자를 지정하지 않고 year와 month만 구하기 때문에 그 해, 그 달의 첫날을 가지고 옴
        guard let startDate = calendar.date(from: calendar.dateComponents([.year, .month],
                                                                          from: self)) else {
            return []
        }
        
        // 해당 월의 일자 범위(날짜 수 가져오는거)
        guard let range = calendar.range(of: .day,
                                         in: .month,
                                         for: startDate) else { return [] }
        
        // range의 각각의 날짜(day)를 Date로 맵핑해서 배열로!!
        return range.compactMap { day -> Date in
            // to: (현재 날짜, 일자)에 day를 더해서 새로운 날짜를 만듦
            calendar.date(byAdding: .day,
                          value: day - 1,
                          to: startDate) ?? Date()
        }
    }
    
}
