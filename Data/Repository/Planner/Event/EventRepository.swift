//
//  EventRepository.swift
//  Polarnal
//
//  Created by 최승범 on 2/26/25.
//

import Foundation
import SwiftData

final class EventRepository: EventRepositoryProtocol {
    
    private let dbManager: DBManager
    private let modelContext: ModelContext
    
    init(dbManager: DBManager = DBManager(), modelContext: ModelContext) {
        self.dbManager = dbManager
        self.modelContext = modelContext
        self.dbManager.modelContext = modelContext
    }
    
    func fetchEvents() -> [EventDB] {
        return dbManager.fetchItems(ofType: EventDB.self)
    }
    
    func deleteEvent(_ event: EventDB) {
        dbManager.deleteItem(event)
    }
}

