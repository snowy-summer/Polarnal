//
//  TravelPlanDB.swift
//  Polarnal
//
//  Created by 최승범 on 12/16/24.
//

import Foundation
import SwiftData

@Model
final class TravelPlanDB: Identifiable {
    @Attribute(.unique) var id: UUID
    var country: String
    var startDate: Date
    var endDate: Date
    @Relationship(deleteRule: .cascade) var todoList: [TravelTodoDB]
    @Relationship(deleteRule: .cascade) var costList: [TravelCost]
    @Relationship(deleteRule: .cascade) var ticketList: [TravelDocument]
    
    init(id: UUID = UUID(),
         country: String,
         startDate: Date,
         endDate: Date,
         todoList: [TravelTodoDB] = [],
         costList: [TravelCost] = [],
         ticketList: [TravelDocument] = []) {
        self.id = id
        self.country = country
        self.startDate = startDate
        self.endDate = endDate
        self.todoList = todoList
        self.costList = costList
        self.ticketList = ticketList
    }
}

@Model
final class TravelTodoDB {
    @Attribute(.unique) var id: UUID
    var content: String
    var isDone: Bool
    
    init(id: UUID = UUID(),
         content: String,
         isDone: Bool = false,
         folder: TodoFolderDB) {
        self.id = id
        self.content = content
        self.isDone = isDone
    }
}

@Model
final class TravelCost {
    @Attribute(.unique) var id: UUID
    var content: String
    var costType: String
    var date: Date
    
    init(id: UUID = UUID(),
         content: String,
         costType: String,
         date: Date) {
        self.id = id
        self.content = content
        self.costType = costType
        self.date = date
    }
}

@Model
final class TravelDocument {
    @Attribute(.unique) var id: UUID
    var title: String
    var type: String
    @Attribute(.externalStorage) var contentImageData: [Data]
    
    init(id: UUID = UUID(),
         title: String,
         type: String,
         contentImageData: [Data] = []) {
        self.id = id
        self.title = title
        self.type = type
        self.contentImageData = contentImageData
    }
}
