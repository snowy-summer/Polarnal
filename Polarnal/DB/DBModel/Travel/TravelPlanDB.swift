//
//  TravelPlanDB.swift
//  Polarnal
//
//  Created by 최승범 on 12/16/24.
//

import Foundation
import SwiftData
// 여행 이름
// 여행 국가
// 여행 기간
// 세부 여행 todo
// 세부 사용한 돈
// 세부 저장한 장소들 ////////////////////////////////////////////////장소 아직 안했음
// 세부 잡다한 티켓 파일
// 리뷰와 기록들

@Model
final class TravelPlanDB: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var country: String
    var startDate: Date
    var endDate: Date
    @Relationship(deleteRule: .cascade) var todoList: [TravelTodoDB]
    @Relationship(deleteRule: .cascade) var costList: [TravelCost]
    @Relationship(deleteRule: .cascade) var ticketList: [TravelDocument]
    
    init(id: UUID = UUID(),
         title: String,
         country: String,
         startDate: Date,
         endDate: Date,
         todoList: [TravelTodoDB] = [],
         costList: [TravelCost] = [],
         ticketList: [TravelDocument] = []) {
        self.id = id
        self.title = title
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
         isDone: Bool = false) {
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
