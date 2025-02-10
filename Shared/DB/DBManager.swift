//
//  DBManager.swift
//  Polarnal
//
//  Created by 최승범 on 12/3/24.
//

import Foundation
import SwiftData

final class DBManager {
    
    var modelContext: ModelContext?
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }
    
    static func makeModelContainer() -> ModelContainer {
        let schema = Schema([
            Folder.self,
            Note.self,
            EventCategoryDB.self,
            EventDB.self,
            DDayDB.self,
            TodoFolderDB.self,
            TodoDB.self
//            TravelPlanDB.self,
//            TravelDestinationFolderDB.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema,
                                                    isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema,
                                      configurations: [modelConfiguration])
        } catch {
            fatalError("ModelContainer를 생성하는데 실패했습니다")
        }
    }
    
}

//MARK: - 데이터베이스 CRUD Method
extension DBManager {
    
    func addItem<T: PersistentModel>(_ model: T) {
        guard let modelContext else {
            LogManager.log("ModelContext가 없습니다")
            return
        }
        
        modelContext.insert(model)
        
        do {
            try modelContext.save()
        } catch {
            LogManager.log("DB 저장 실패")
        }
    }
    
    func fetchItems<T: PersistentModel>(ofType type: T.Type) -> [T]  {
        guard let modelContext else {
            LogManager.log("ModelContext가 없습니다")
            return []
        }
        
        let request = FetchDescriptor<T>()
        
        do {
            let items: [T] = try modelContext.fetch(request)
            return items
        } catch {
            LogManager.log("불러오기 실패")
            return []
        }
    }
    
    func deleteItem<T: PersistentModel>(_ model: T) {
        guard let modelContext else {
            LogManager.log("ModelContext가 없습니다")
            return
        }
        
        modelContext.delete(model)
        
        do {
            try modelContext.save()
        } catch {
            LogManager.log("DB삭제 실패 \(model)")
        }
    }
    
}
