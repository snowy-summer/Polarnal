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
    @Relationship(deleteRule: .cascade) var contents: [NoteContentData]
    
    init(createAt: Date = Date(),
         title: String = "",
         tag: [Tag] = [],
         contents: [NoteContentData] = []) {
        self.createAt = createAt
        self.title = title
        self.tag = tag
        self.contents = contents
    }
}

enum NoteContentType: String {
    case text
    case image
}

@Model
final class NoteContentData: Identifiable {
    @Attribute(.unique) var id: UUID
    @Attribute(.externalStorage) var textValue: String
    @Attribute(.externalStorage) var imageValue: [Data]
    var type: String

    init(type: NoteContentType,
         imageValue: [Data],
         textValue: String) {
        self.id = UUID()
        self.type = type.rawValue
        self.imageValue = imageValue
        self.textValue = textValue
    }
}

@Model
final class Tag {
    var content: String
    
    init(content: String) {
        self.content = content
    }
}

