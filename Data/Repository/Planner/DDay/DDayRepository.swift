//
//  DDayRepository.swift
//  Polarnal
//
//  Created by 최승범 on 2/26/25.
//

import Foundation
import SwiftData

final class DDayRepository: DDayRepositoryProtocol {
    
    private let dbManager: DBManager
    private let dateManager = DateManager.shared
    private let modelContext: ModelContext
    
    init(dbManager: DBManager = DBManager(), modelContext: ModelContext) {
        self.dbManager = dbManager
        self.modelContext = modelContext
        self.dbManager.modelContext = modelContext
    }
    
    func fetchDDay() -> [DDayDB] {
        return dbManager.fetchItems(ofType: DDayDB.self)
    }
    
    func deleteDDay(_ DDay: DDayDB) {
        dbManager.deleteItem(DDay)
    }
}
