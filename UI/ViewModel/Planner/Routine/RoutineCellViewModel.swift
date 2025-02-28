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
        case sortRoutine
    }
    
    private var useCase: RoutineUseCaseProtocol
    private let dateManager = DateManager.shared
    var cancellables: Set<AnyCancellable> = []
    
    @Published var routineDB: RoutineDB
    var streakCount: Int {
        guard let items = routineDB.routineItems else { return 0 }
        return items.prefix { $0.isDone }.count
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
           !items.isEmpty {
            let item = items.first {  dateManager.getDateString(date: $0.date) == dateManager.getDateString(date: Date())
            }
            
            if let item = item,
               item.isDone == false {
                return false
            } else {
                return true
            }
            
        }
        
        return false
        
    }
    
    init(routine: RoutineDB,
         useCase: RoutineUseCaseProtocol) {
        routineDB = routine
        self.useCase = useCase
    }
    
    func apply(_ intent: Intent) {

        switch intent {
        case .doenTodayRoutine:
            useCase.doneTodayRoutine(routineDB)
            routineDB.routineItems?.sort { $0.date < $1.date }
            
        case .sortRoutine:
            routineDB.routineItems?.sort { $0.date < $1.date }
        }
    }
    
}
