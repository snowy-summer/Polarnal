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
    @Attribute(.unique) let id: UUID
    var content: String
    var isPeriod: Bool
    var date: Date
    var endDate: Date?
    @Relationship(deleteRule: .nullify) var category: EventCategoryDB
    
    init(id: UUID = UUID(),
         content: String,
         isPeriod: Bool,
         date: Date,
         endDate: Date? = nil,
         category: EventCategoryDB) {
        self.id = id
        self.content = content
        self.isPeriod = isPeriod
        self.date = date
        self.endDate = endDate
        self.category = category
    }
}
