//
//  FolderDB.swift
//  Polarnal
//
//  Created by 최승범 on 12/3/24.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class Folder: Identifiable {
    @Attribute(.unique) var id = UUID()
    var title: String
    var createAt: Date
    @Relationship(deleteRule: .cascade) var color: CustomColor
    var icon: String
    var tag: [Tag]
    @Relationship(deleteRule: .cascade) var noteList: [Note]
    
    init(title: String,
         color: CustomColor = CustomColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0),
         icon: String = "",
         createAt: Date = Date(),
         tag: [Tag] = [],
         noteList: [Note] = []) {
        self.title = title
        self.color = color
        self.icon = icon
        self.createAt = createAt
        self.tag = tag
        self.noteList = noteList
    }
}

@Model
final class CustomColor {
    var red: Double
    var green: Double
    var blue: Double
    var alpha: Double
    
    init(red: Double,
         green: Double,
         blue: Double,
         alpha: Double) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    func convertToColor() -> Color {
        return Color(red: red,
                     green: green,
                     blue: blue,
                     opacity: alpha)
    }
}
