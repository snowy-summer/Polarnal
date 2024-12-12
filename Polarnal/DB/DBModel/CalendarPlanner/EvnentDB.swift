//
//  EventDB.swift
//  Polarnal
//
//  Created by 최승범 on 12/10/24.
//

import Foundation
import SwiftData


@Model
final class EventCategoryDB {
    @Attribute(.unique) let id = UUID()
    var title: String
    @Relationship(deleteRule: .cascade) var planList: [EventDB]
    @Relationship(deleteRule: .cascade) var color: CustomColor
    
    init(planList: [EventDB] = [],
         title: String,
         color: CustomColor = CustomColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)) {
        self.planList = planList
        self.title = title
        self.color = color
    }
    
}

@Model
final class EventDB {
    @Attribute(.unique) let id = UUID()
    var content: String
    var date: Date
    
    init(content: String, date: Date) {
        self.content = content
        self.date = date
    }
}

@Model
final class DDayDB {
    @Attribute(.unique) let id = UUID()
    var title: String
    var startDate: Date
    var goalDate: Date
    var type: String
    
    init(title: String,
         startDate: Date,
         goalDate: Date,
         type: String) {
        self.title = title
        self.startDate = startDate
        self.goalDate = goalDate
        self.type = type
    }
}
