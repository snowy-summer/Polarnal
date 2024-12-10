//
//  Plan.swift
//  Polarnal
//
//  Created by 최승범 on 12/10/24.
//

import Foundation
import SwiftData


@Model
final class PlanCategory {
    @Attribute(.unique) let id = UUID()
    @Relationship(deleteRule: .cascade) var planList: [PlanDB]
    @Relationship(deleteRule: .cascade) var color: CustomColor
    
    init(planList: [PlanDB],
         color: CustomColor = CustomColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)) {
        self.planList = planList
        self.color = color
    }
    
}

@Model
final class PlanDB {
    @Attribute(.unique) let id = UUID()
    var content: String
    var date: Date
    
    init(content: String, date: Date) {
        self.content = content
        self.date = date
    }
}
