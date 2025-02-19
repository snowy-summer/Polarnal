//
//  RoutineCellViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 2/19/25.
//

import Foundation
import Combine
import SwiftData

final class RoutineCellViewModel: ViewModelProtocol {
    
    enum Intent {
        case doenTodayRoutine
        case insertModelContext(ModelContext)
    }
    
    var cancellables: Set<AnyCancellable> = []
    
    @Published var routineDB: RoutineDB
    private let dbManager = DBManager()
    private let dateManager = DateManager.shared
    var streakCount: Int {
        guard let items = routineDB.routineItems else { return 0 }
        return items.reversed().prefix { $0.isDone }.count
    }
    
    var isDoneDisabled: Bool {
        guard let repeatDays = routineDB.repeatDays else {
            LogManager.log("반복 요일이 존재하지 않습니다")
            return true
        }
        guard let today = dateManager.getWeekday(from: Date()) else {
            LogManager.log("잘못된 날짜입니다. 현재 날짜 -> 요일 변경 실패")
            return true
        }
        
        if !repeatDays.contains(today) { return true }
        
        if let items = routineDB.routineItems,
           !items.isEmpty,
           let lastDate = items.last?.date {
            
            let lastDateString = dateManager.getDateString(date: lastDate)
            let todayDateString = dateManager.getDateString(date: Date())
            
            if lastDateString == todayDateString {
                return true
            }
        }
        
        return false
        
    }
    
    init(routine: RoutineDB) {
        routineDB = routine
    }
    
    func apply(_ intent: Intent) {
        
        switch intent {
        case .doenTodayRoutine:
            routineDB.routineItems?.append(RoutineItemDB(isDone: true))
            dbManager.addItem(routineDB)
            
        case .insertModelContext(let model):
            dbManager.modelContext = model
        }
    }
    
}
