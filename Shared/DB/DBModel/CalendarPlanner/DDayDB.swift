//
//  DDayDB.swift
//  Polarnal
//
//  Created by 최승범 on 12/12/24.
//

import Foundation
import SwiftData

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
