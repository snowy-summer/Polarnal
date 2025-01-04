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
    
    init(id: UUID = UUID(),
         title: String,
         type: String,
         date: Date? = nil,
         destinationList: [TravelDestinationDB] = [],
         travelPlanID: UUID) {
        self.id = id
        self.title = title
        self.type = type
        self.date = date
        self.destinationList = destinationList
        self.travelPlanID = travelPlanID
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
