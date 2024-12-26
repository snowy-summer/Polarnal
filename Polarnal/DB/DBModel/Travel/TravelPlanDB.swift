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
    @Relationship(deleteRule: .cascade) var costList: [TravelCostDB]
    @Relationship(deleteRule: .cascade) var ticketList: [TravelDocumentDB]
    @Relationship(deleteRule: .cascade) var planDetailList: [TravelPlanDetailDB]
    
    init(id: UUID = UUID(),
         title: String,
         country: String,
         startDate: Date,
         endDate: Date,
         todoList: [TravelTodoDB] = [],
         costList: [TravelCostDB] = [],
         ticketList: [TravelDocumentDB] = [],
         planDetailList: [TravelPlanDetailDB] = []) {
        self.id = id
        self.title = title
        self.country = country
        self.startDate = startDate
        self.endDate = endDate
        self.todoList = todoList
        self.costList = costList
        self.ticketList = ticketList
        self.planDetailList = planDetailList
    }
}

@Model
final class TravelPlanDetailDB: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var type: String
    var date: Date
    var destination: String?
    var isDone: Bool
    var travelPlanID: UUID
    
    init(id: UUID = UUID(),
         title: String,
         type: String,
         date: Date,
         destination: String? = nil,
         isDone: Bool = false,
         travelPlanID: UUID) {
        self.id = id
        self.title = title
        self.type = type
        self.date = date
        self.destination = destination
        self.isDone = isDone
        self.travelPlanID = travelPlanID
    }
}

@Model
final class TravelTodoDB {
    @Attribute(.unique) var id: UUID
    var content: String
    var isDone: Bool
    var travelPlanID: UUID
    
    init(id: UUID = UUID(),
         content: String,
         isDone: Bool = false,
         travelPlanID: UUID) {
        self.id = id
        self.content = content
        self.isDone = isDone
        self.travelPlanID = travelPlanID
    }
}

@Model
final class TravelCostDB {
    @Attribute(.unique) var id: UUID
    
    var spentCost: Double
    var spentCostType: String
    
    var convertedCost: Double
    var convertedCostType: String
    
    var content: String
    var costType: String
    var date: Date
    var travelPlanID: UUID
    @Attribute(.externalStorage) var imageDataList: [Data]
    
    init(id: UUID = UUID(),
         spentCost: Double,
         spentCostType: String,
         convertedCost: Double,
         convertedCostType: String,
         content: String,
         costType: String,
         date: Date,
         travelPlanID: UUID,
         imageDataList: [Data] = []) {
        self.id = id
        self.spentCost = spentCost
        self.spentCostType = spentCostType
        self.convertedCost = convertedCost
        self.convertedCostType = convertedCostType
        self.content = content
        self.costType = costType
        self.date = date
        self.travelPlanID = travelPlanID
        self.imageDataList = imageDataList
    }
}

@Model
final class TravelDocumentDB {
    @Attribute(.unique) var id: UUID
    var title: String
    var content: String
    var type: String
    var travelPlanID: UUID
    @Attribute(.externalStorage) var contentImageData: [Data]
    
    init(id: UUID = UUID(),
         title: String,
         content: String,
         type: String,
         travelPlanID: UUID,
         contentImageData: [Data] = []) {
        self.id = id
        self.title = title
        self.content = content
        self.type = type
        self.travelPlanID = travelPlanID
        self.contentImageData = contentImageData
    }
}
