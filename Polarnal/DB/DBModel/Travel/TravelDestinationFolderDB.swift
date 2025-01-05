//
//  TravelDestinationFolder.swift
//  Polarnal
//
//  Created by 최승범 on 1/4/25.
//

import Foundation
import SwiftData

@Model
final class TravelDestinationFolderDB: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var type: String
    var date: Date?
    var destinationList: [TravelDestinationDB]
    let travelPlanID: UUID
    @Relationship(deleteRule: .cascade) var color: CustomColor
    
    init(id: UUID = UUID(),
         title: String,
         type: String,
         date: Date? = nil,
         destinationList: [TravelDestinationDB] = [],
         travelPlanID: UUID,
         color: CustomColor = CustomColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)) {
        self.id = id
        self.title = title
        self.type = type
        self.date = date
        self.destinationList = destinationList
        self.travelPlanID = travelPlanID
        self.color = color
    }
}

@Model
final class TravelDestinationDB: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var type: String
    var date: Date?
    var destination: String?
    var travelPlanID: UUID
    
    init(id: UUID = UUID(),
         title: String,
         type: String,
         date: Date? = nil,
         destination: String? = nil,
         travelPlanID: UUID) {
        self.id = id
        self.title = title
        self.type = type
        self.date = date
        self.destination = destination
        self.travelPlanID = travelPlanID
    }
}
