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
final class Folder: Identifiable, Hashable {
    var id = UUID()
    var title: String = ""
    var createAt: Date = Date()
    var colorCode: String = "#FFFFFF"
    var icon: String = "pencil"
    var tag: [String] = []
    @Relationship(deleteRule: .cascade) var noteList: [Note]?
    
    init(title: String,
         colorCode: String = "#FFFFFF",
         icon: String = "",
         createAt: Date = Date(),
         tag: [String] = [],
         noteList: [Note] = []) {
        self.title = title
        self.colorCode = colorCode
        self.icon = icon
        self.createAt = createAt
        self.tag = tag
        self.noteList = noteList
    }
}
