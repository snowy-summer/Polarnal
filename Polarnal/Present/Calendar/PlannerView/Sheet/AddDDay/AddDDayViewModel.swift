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
    
    init(dday: DDayDB?) {
        if let dday {
            self.dday = dday
            ddayTitle = dday.title
            startDate = dday.startDate
            goalDate = dday.goalDate
            if DDayType(rawValue: dday.type) == .DDay {
                isDDay = true
                isDPlus = false
            }
            else {
                isDPlus = true
                isDDay = false
            }
        } else {
            ddayTitle = ""
        }
    }
    
    enum Intent {
        case saveDday
        case insertModelContext(ModelContext)
        
        case selectCategory(EventCategoryDB)
        case selectDDay
        case selectDPlus
    }
    
    private let dbManager = DBManager()
    var cancellables = Set<AnyCancellable>()
    
    func apply(_ intent: Intent) {
        switch intent {
        case .saveDday:
            dday == nil ? saveDday() : editSaveDday()
            
        case .insertModelContext(let modelContext):
            dbManager.modelContext = modelContext
            
        case .selectCategory(let category):
            selectedCategory = category
            
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
 
    private func saveDday() {
        if isDDay {
            dbManager.addItem(DDayDB(title: ddayTitle,
                                     startDate: startDate,
                                     goalDate: goalDate,
                                     type: DDayType.DDay.rawValue))
        } else {
            dbManager.addItem(DDayDB(title: ddayTitle,
                                     startDate: startDate,
                                     goalDate: goalDate,
                                     type: DDayType.DPlus.rawValue))
        }
        
    }
    
    private func editSaveDday() {
        dday?.title = ddayTitle
        dday?.startDate = startDate
        dday?.goalDate = goalDate
        dday?.type = isDDay ? DDayType.DDay.rawValue : DDayType.DPlus.rawValue
        
        if let dday {
            dbManager.addItem(dday)
        } else {
            LogManager.log("DDay 저장 실패")
        }
    }
    
}

enum DDayType: String {
    case DDay
    case DPlus
}

