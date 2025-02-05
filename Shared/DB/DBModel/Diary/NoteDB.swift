//
//  NoteDB.swift
//  Polarnal
//
//  Created by 최승범 on 12/3/24.
//

import Foundation
import SwiftData

@Model
final class Note: Identifiable, Hashable {
    @Attribute(.unique)var id = UUID()
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
final class NoteContentDataDB: Identifiable, Hashable {
    @Attribute(.unique) var id: UUID
    @Relationship(deleteRule: .cascade) var imagePaths: [ImagePath]
    var textValue: String
    var type: String
    var index: Int
    var noteID: UUID

    init(id: UUID = UUID(),
         type: NoteContentType,
         imagePaths: [ImagePath] = [],
         textValue: String = "",
         index: Int,
         noteID: UUID) {
        self.id = id
        self.type = type.rawValue
        self.imagePaths = imagePaths
        self.textValue = textValue
        self.index = index
        self.noteID = noteID
    }
}

@Model
final class ImagePath: Identifiable, Hashable {
    @Attribute(.unique) var id: String
    
    init(id: String) {
        self.id = id
    }
}

@Model
final class Tag: Hashable {
    var content: String
    
    init(content: String) {
        self.content = content
    }
}

