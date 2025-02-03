//
//  Item.swift
//  MacPolarnal
//
//  Created by 최승범 on 2/3/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
