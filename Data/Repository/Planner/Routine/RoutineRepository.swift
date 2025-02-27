//
//  RoutineRepository.swift
//  Polarnal
//
//  Created by 최승범 on 2/27/25.
//

import Foundation
import SwiftData

final class RoutineRepository: RoutineRepositoryProtocol {
    private let dbManager: DBManager
    private let modelContext: ModelContext
    
    init(dbManager: DBManager = DBManager(),
         modelContext: ModelContext) {
        self.dbManager = dbManager
        self.modelContext = modelContext
        self.dbManager.modelContext = modelContext
    }
    
    func addRoutine(_ routine: RoutineDB) {
        dbManager.addItem(routine)
        
    }
    
    func deleteRoutine(_ routine: RoutineDB) {
        dbManager.deleteItem(routine)
    }
    
    func fetchRoutineList() -> [RoutineDB] {
        dbManager.fetchItems(ofType: RoutineDB.self)
    }
    
    func fetchRoutine(_ id: UUID) -> RoutineDB? {
        dbManager.fetchItems(ofType: RoutineDB.self).first {
            id == $0.id
        }
    }
}
