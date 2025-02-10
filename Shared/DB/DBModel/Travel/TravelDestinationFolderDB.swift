//
//  TravelDestinationFolder.swift
//  Polarnal
//
//  Created by 최승범 on 1/4/25.
//

import Foundation
import SwiftData
import CoreLocation

@Model
final class TravelDestinationFolderDB: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var type: String
    var date: Date?
    var destinationList: [TravelDestinationDB]
    var travelPlanID: UUID
    var colorCode: String
    
    init(id: UUID = UUID(),
         title: String,
         type: String,
         date: Date? = nil,
         destinationList: [TravelDestinationDB] = [],
         travelPlanID: UUID,
         colorCode: String = "#FFFFFF") {
        self.id = id
        self.title = title
        self.type = type
        self.date = date
        self.destinationList = destinationList
        self.travelPlanID = travelPlanID
        self.colorCode = colorCode
    }
}

@Model
final class TravelDestinationDB: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var type: String
    var date: Date?
    var destination: String?
    var longitude: Double
    var latitude: Double
    var travelPlanID: UUID
    
    init(id: UUID = UUID(),
         title: String,
         type: String,
         date: Date? = nil,
         destination: String? = nil,
         longitude: Double,
         latitude: Double,
         travelPlanID: UUID) {
        self.id = id
        self.title = title
        self.type = type
        self.date = date
        self.destination = destination
        self.longitude = longitude
        self.latitude = latitude
        self.travelPlanID = travelPlanID
    }
}

struct MapPlace: Identifiable {
    var id: UUID
    var title: String
    var type: String
    var date: Date?
    var destination: String?
    var longitude: Double
    var latitude: Double
    var travelPlanID: UUID
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude,
                               longitude: longitude)
    }
    
    init(id: UUID = UUID(),
         title: String,
         type: String,
         date: Date? = nil,
         destination: String? = nil,
         longitude: Double,
         latitude: Double,
         travelPlanID: UUID) {
        
        self.id = id
        self.title = title
        self.type = type
        self.date = date
        self.destination = destination
        self.longitude = longitude
        self.latitude = latitude
        self.travelPlanID = travelPlanID
    }
    
    init(destination: TravelDestinationDB) {
        id = destination.id
        title = destination.title
        type = destination.type
        date = destination.date
        self.destination = destination.destination
        longitude = destination.longitude
        latitude = destination.latitude
        travelPlanID = destination.travelPlanID
    }
    
}
