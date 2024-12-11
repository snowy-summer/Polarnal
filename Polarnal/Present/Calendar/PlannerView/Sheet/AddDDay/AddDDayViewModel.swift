//
//  AddDDayViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/11/24.
//

import SwiftUI
import Combine
import SwiftData

final class AddDDayViewModel: ViewModelProtocol {
    
    @Published var ddayTitle: String
    @Published var isDDay: Bool = true
    @Published var isDPlus: Bool = false
    @Published var selectedCategory: EventCategoryDB?
    @Published var startDate: Date = Date()
    @Published var goalDate: Date = Date()
    
    @Published var showCategory: Bool = false
    var categoryList = [EventCategoryDB]()
    
    private var dday: DDayDB?
    
    init(eventCategory: DDayDB?) {
        if let dday {
            self.dday = dday
            ddayTitle = dday.title
        } else {
            ddayTitle = ""
        }
    }
    
    enum Intent {
        case saveDday
        case insertModelContext(ModelContext)
        
        case selectDDay
        case selectDPlus
    }
    
    private let dbManager = DBManager()
    var cancellables = Set<AnyCancellable>()
    
    func apply(_ intent: Intent) {
        switch intent {
        case .saveDday:
//            eventCategory == nil ? addFolder() : editFolder()
            return
            
        case .insertModelContext(let modelContext):
            dbManager.modelContext = modelContext
            
        case .selectDDay:
            if !isDDay { isDDay = true }
            if isDDay { isDPlus = false }
            
        case .selectDPlus:
            if !isDPlus { isDPlus = true }
            if isDPlus { isDDay = false }
        }
    }
}

extension AddDDayViewModel {
    
    private func addFolder() {
        
//        let newCategory = EventCategoryDB(title: categoryTitle,
//                                          color: getColorRGBA())
//        dbManager.addItem(newCategory)
    }
    
    private func editFolder() {
//        if eventCategory != nil {
//            eventCategory?.title = categoryTitle
//            eventCategory?.color = getColorRGBA()
//           
//            dbManager.addItem(eventCategory!)
//        }
    }
    
//    private func getColorRGBA() -> CustomColor {
//        
//        let uiColor = UIColor(categoryColor)
//        
//        var red: CGFloat = 0
//        var green: CGFloat = 0
//        var blue: CGFloat = 0
//        var alpha: CGFloat = 0
//        
//        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
//        
//        return CustomColor(red: red, green: green, blue: blue, alpha: alpha)
//    }
    
}



