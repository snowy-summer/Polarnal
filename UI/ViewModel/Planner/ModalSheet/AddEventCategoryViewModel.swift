//
//  AddEventCategoryViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/11/24.
//

import SwiftUI
import Combine
import SwiftData

final class AddEventCategoryViewModel: ViewModelProtocol {
    
    @Published var categoryTitle: String
    @Published var categoryColor: Color
    private var eventCategory: EventCategoryDB?
    
    init(eventCategory: EventCategoryDB?) {
        if let eventCategory {
            self.eventCategory = eventCategory
            categoryTitle = eventCategory.title
            categoryColor = Color(hex: eventCategory.colorCode)
//            categoryColor = Color(red: eventCategory.color.red,
//                                  green: eventCategory.color.green,
//                                  blue: eventCategory.color.blue,
//                                  opacity: eventCategory.color.alpha)
        } else {
            categoryTitle = ""
            categoryColor = .blue
        }
    }
    
    enum Intent {
        
        case selectColor(Color)
        case saveCategory
        case insertModelContext(ModelContext)
        
    }
    
    private let dbManager = DBManager()
    var cancellables = Set<AnyCancellable>()
    
    func apply(_ intent: Intent) {
        switch intent {
        case .selectColor(let color):
            categoryColor = color
            
        case .saveCategory:
            eventCategory == nil ? addFolder() : editFolder()
            
        case .insertModelContext(let modelContext):
            dbManager.modelContext = modelContext
        }
    }
}

extension AddEventCategoryViewModel {
    
    private func addFolder() {
        if let hexCode = categoryColor.toHex() {
            let newCategory = EventCategoryDB(title: categoryTitle,
                                              colorCode: hexCode)
            dbManager.addItem(newCategory)
        }
    }
    
    private func editFolder() {
        if eventCategory != nil {
            eventCategory?.title = categoryTitle
            if let hexCode = categoryColor.toHex() {
                eventCategory?.colorCode = hexCode
            }
//            eventCategory?.color = getColorRGBA()
           
            dbManager.addItem(eventCategory!)
        }
    }
    
}



