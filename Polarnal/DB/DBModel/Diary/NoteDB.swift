//
//  NoteDB.swift
//  Polarnal
//
//  Created by 최승범 on 12/3/24.
//

import Foundation
import SwiftData

@Model
final class Note: Identifiable {
    @Attribute(.unique)let id = UUID()
    var createAt: Date
    var title: String
    var tag: [Tag]
    @Relationship(deleteRule: .cascade) var contents: [NoteContentDataDB]
    var folderID: UUID
    
    init(createAt: Date = Date(),
         title: String = "",
         tag: [Tag] = [],
         contents: [NoteContentDataDB] = [],
         folderID: UUID) {
        
        self.createAt = createAt
        self.title = title
        self.tag = tag
        self.contents = contents
        self.folderID = folderID
    }
}

enum NoteContentType: String {
    case text
    case image
}

@Model
final class NoteContentDataDB: Identifiable {
    @Attribute(.unique) var id: UUID
    @Attribute(.externalStorage) var textValue: String
    @Attribute(.externalStorage) var imageValue: [Data]
    var type: String
    var index: Int
    var noteID: UUID

    init(id: UUID = UUID(),
         type: NoteContentType,
         imageValue: [Data] = [],
         textValue: String = "",
         index: Int,
         noteID: UUID) {
        self.id = id
        self.type = type.rawValue
        self.imageValue = imageValue
        self.textValue = textValue
        self.index = index
        self.noteID = noteID
    }
}

@Model
final class Tag {
    var content: String
    
    init(content: String) {
        self.content = content
    }
}

