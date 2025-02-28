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
    var id = UUID()
    var createAt: Date = Date()
    var title: String = ""
    var tag: [String] = []
    @Relationship(deleteRule: .cascade) var contents: [NoteContentDataDB]?
    @Relationship(deleteRule: .nullify, inverse: \Folder.noteList) var folder: Folder?
    
    init(createAt: Date = Date(),
         title: String = "",
         tag: [String] = [],
         contents: [NoteContentDataDB] = [],
         folder: Folder) {
        
        self.createAt = createAt
        self.title = title
        self.tag = tag
        self.contents = contents
        self.folder = folder
    }
}

enum NoteContentType: String {
    case text
    case image
}

@Model
final class NoteContentDataDB: Identifiable, Hashable {
    var id: UUID = UUID()
    @Relationship(deleteRule: .cascade) var imagePaths: [ImagePath]?
    var textValue: String = ""
    var type: String = ""
    var index: Int = 0
    @Relationship(deleteRule: .nullify, inverse: \Note.contents) var note: Note?

    init(id: UUID = UUID(),
         type: NoteContentType,
         imagePaths: [ImagePath] = [],
         textValue: String = "",
         index: Int,
         note: Note) {
        self.id = id
        self.type = type.rawValue
        self.imagePaths = imagePaths
        self.textValue = textValue
        self.index = index
        self.note = note
    }
}

@Model
final class ImagePath: Identifiable, Hashable {
    var id: String = ""
    var cloudPath: String = ""
    @Relationship(deleteRule: .nullify, inverse: \NoteContentDataDB.imagePaths) var noteContentData: NoteContentDataDB?
    
    init(id: String,
         cloudPath: String) {
        self.id = id
        self.cloudPath = cloudPath
    }
}

@Model
final class Tag: Hashable {
    var content: String = ""
    
    init(content: String) {
        self.content = content
    }
}

