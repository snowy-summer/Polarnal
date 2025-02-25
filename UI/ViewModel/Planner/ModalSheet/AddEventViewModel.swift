//
//  AddEventViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/13/24.
//

import SwiftUI
import Combine
import SwiftData

final class AddEventViewModel: ViewModelProtocol {
    
    @Published var eventContent: String
    @Published var selectedCategory: EventCategoryDB?
    @Published var isPeriod: Bool = false
    @Published var startDate: Date = Date()
    @Published var goalDate: Date = Date()
    var categoryList = [EventCategoryDB]()
    
    private var eventData: EventDB?
    
    init(eventData: EventDB?) {
        if let eventData {
            eventContent = eventData.content
            selectedCategory = eventData.category
            isPeriod = eventData.isPeriod
            startDate = eventData.date
            goalDate = eventData.endDate ?? Date()
        } else {
            eventContent = ""
        }
    }
    
    enum Intent {
        case saveEvent
        case insertModelContext(ModelContext)
        
        case selectCategory(EventCategoryDB)
    }
    
    private let dbManager = DBManager()
    var cancellables = Set<AnyCancellable>()
    
    func apply(_ intent: Intent) {
        switch intent {
        case .saveEvent:
            eventData == nil ? saveEvent() : editSaveEvent()
            
        case .insertModelContext(let modelContext):
            dbManager.modelContext = modelContext
            if !dbManager.fetchItems(ofType: EventCategoryDB.self).isEmpty {
                selectedCategory = dbManager.fetchItems(ofType: EventCategoryDB.self)[0]
            }
            
            
        case .selectCategory(let category):
            selectedCategory = category
        }
    }
}

extension AddEventViewModel {
    
    private func saveEvent() {
        if let selectedCategory {
            let event = EventDB(content: eventContent,
                                isPeriod: isPeriod,
                                date: startDate,
                                endDate: isPeriod ? goalDate : Date(),
                                category: selectedCategory)
            dbManager.addItem(event)
            selectedCategory.planList?.append(event)
            dbManager.addItem(selectedCategory)
        }
    }
    
    private func editSaveEvent() {
        eventData?.content = eventContent
        eventData?.date = startDate
        eventData?.endDate = goalDate
        if let selectedCategory,
           let eventData {
            eventData.category = selectedCategory
            dbManager.addItem(eventData)
            selectedCategory.planList?.append(eventData)
            dbManager.addItem(selectedCategory)
        } else {
            LogManager.log("Event 수정 실패")
        }

    }
    
}
