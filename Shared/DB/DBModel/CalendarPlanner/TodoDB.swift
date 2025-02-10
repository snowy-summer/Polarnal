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
    var colorCode: String
    
    init(id: UUID = UUID(),
         title: String,
         todoList: [TodoDB] = [],
         colorCode: String = "#FFFFFF") {
        self.id = id
        self.title = title
        self.todoList = todoList
        self.colorCode = colorCode
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
