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
    var id: UUID = UUID()
    var title: String = ""
    @Relationship(deleteRule: .cascade) var todoList: [TodoDB]?
    var colorCode: String = ""
    
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
    var id: UUID = UUID()
    var content: String = ""
    var isDone: Bool = false
    @Relationship(deleteRule: .nullify, inverse: \TodoFolderDB.todoList) var folder: TodoFolderDB?
    
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
