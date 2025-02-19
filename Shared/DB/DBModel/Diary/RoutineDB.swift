//
//  RoutineDB.swift
//  Polarnal
//
//  Created by 최승범 on 2/19/25.
//

import Foundation
import SwiftData

@Model
final class RoutineDB {
    var id: UUID = UUID()
    var name: String = ""
    var startDate: Date = Date()
    var repeatDays: Set<Day>?
    var repeatInterval: Int = 1 // 반복 주기 1 = 매주, 2 = 격주, 3 = 3주마다
    @Relationship(deleteRule: .cascade) var routineItems: [RoutineItemDB]?
    var colorCode: String = "#FFFFFF"
    
    var isPushEnabled: Bool = false
    var pushTime: Date?
    
    init(name: String,
         startDate: Date = Date(),
         repeatDays: Set<Day> = [],
         repeatInterval: Int = 1,
         routineItems: [RoutineItemDB] = [],
         colorCode: String = "#FFFFFF",
         isPushEnabled: Bool = false,
         pushTime: Date? = nil) {
        self.name = name
        self.startDate = startDate
        self.repeatDays = repeatDays
        self.repeatInterval = repeatInterval
        self.routineItems = routineItems
        self.colorCode = colorCode
        self.isPushEnabled = isPushEnabled
        self.pushTime = pushTime
    }
}

@Model
final class RoutineItemDB {
    var id: UUID = UUID()
    var date: Date = Date()
    var isDone: Bool = false
    @Relationship(deleteRule: .nullify,
                  inverse: \RoutineDB.routineItems) var routine: RoutineDB?
    
    init(date: Date = Date(),
         isDone: Bool = false,
         routine: RoutineDB? = nil) {
        self.date = date
        self.isDone = isDone
        self.routine = routine
    }
}

enum Day: String, CaseIterable, Codable {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    
    var name: String {
        switch self {
        case .sunday:
            return "Sun"
        case .monday:
            return "Mon"
        case .tuesday:
            return "Tue"
        case .wednesday:
            return "Wed"
        case .thursday:
            return "Thu"
        case .friday:
            return "Fri"
        case .saturday:
            return "Sat"
        }
    }
}
