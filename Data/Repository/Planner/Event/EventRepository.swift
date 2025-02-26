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
    private let dateManager = DateManager.shared
    private let modelContext: ModelContext
    
    init(dbManager: DBManager = DBManager(), modelContext: ModelContext) {
        self.dbManager = dbManager
        self.modelContext = modelContext
        self.dbManager.modelContext = modelContext
    }
    
    func fetchEvents(for date: Date) -> [EventDB] {
        let allEventList = dbManager.fetchItems(ofType: EventDB.self)
        return allEventList.filter {
            dateManager.getDateString(date: date) == dateManager.getDateString(date: $0.date)
        }.sorted {
            guard let categoryA = $0.category, let categoryB = $1.category else {
                return $0.category != nil
            }
            return categoryA.title < categoryB.title
        }

    }
}
