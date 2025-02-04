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
    @Attribute(.unique) var id = UUID()
    var title: String
    var colorCode: String
    @Relationship(deleteRule: .cascade) var planList: [EventDB]
    
    init(planList: [EventDB] = [],
         title: String,
         colorCode: String = "#FFFFFF") {
        self.planList = planList
        self.title = title
        self.colorCode = colorCode
    }
    
}

@Model
final class EventDB {
    @Attribute(.unique) var id: UUID
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
