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
    
    init(id: UUID = UUID(),
         country: String,
         startDate: Date,
         endDate: Date) {
        self.id = id
        self.country = country
        self.startDate = startDate
        self.endDate = endDate
    }
}
