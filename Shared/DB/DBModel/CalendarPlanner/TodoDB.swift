//
//  TodoDB.swift
//  Polarnal
//
//  Created by 최승범 on 12/12/24.
//

import Foundation
import SwiftData

@Model
final class TodoFolderDB {
    @Attribute(.unique) var id: UUID
    var title: String
    @Relationship(deleteRule: .cascade) var todoList: [TodoDB]
    @Relationship(deleteRule: .cascade) var color: CustomColor
    
    init(id: UUID = UUID(),
         title: String,
         todoList: [TodoDB] = [],
         color: CustomColor = CustomColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)) {
        self.id = id
        self.title = title
        self.todoList = todoList
        self.color = color
    }
}

@Model
final class TodoDB {
    @Attribute(.unique) var id: UUID
    var content: String
    var isDone: Bool
    @Relationship(deleteRule: .nullify) var folder: TodoFolderDB
    
    init(id: UUID = UUID(),
         content: String,
         isDone: Bool = false,
         folder: TodoFolderDB) {
        self.id = id
        self.content = content
        self.isDone = isDone
        self.folder = folder
    }
}
