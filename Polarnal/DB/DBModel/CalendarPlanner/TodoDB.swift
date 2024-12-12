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
    
    init(id: UUID = UUID(),
         title: String,
         todoList: [TodoDB]) {
        self.id = id
        self.title = title
        self.todoList = todoList
    }
}

@Model
final class TodoDB {
    @Attribute(.unique) var id: UUID
    var content: String
    var isDone: Bool
    
    init(id: UUID = UUID(),
         content: String,
         isDone: Bool = false) {
        self.id = id
        self.content = content
        self.isDone = isDone
    }
}
