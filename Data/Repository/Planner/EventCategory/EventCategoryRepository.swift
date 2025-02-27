//
//  EventCategoryRepository.swift
//  Polarnal
//
//  Created by 최승범 on 2/27/25.
//

import Foundation
import SwiftData

final class EventCategoryRepository: EventCategoryRepositoryProtocol {
    
    private let dbManager: DBManager
    private let modelContext: ModelContext
    
    init(dbManager: DBManager = DBManager(), modelContext: ModelContext) {
        self.dbManager = dbManager
        self.modelContext = modelContext
        self.dbManager.modelContext = modelContext
    }
    
    func deleteEventCategory(_ category: EventCategoryDB) {
        dbManager.deleteItem(category)
    }
}
