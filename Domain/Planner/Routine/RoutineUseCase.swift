//
//  RoutineUseCase.swift
//  Polarnal
//
//  Created by 최승범 on 2/27/25.
//

import Foundation

protocol RoutineUseCaseProtocol {
    func saveRoutine(_ routine: RoutineDB)
    func deleteRoutine(_ routine: RoutineDB)
    func fetchRoutine(_ routineID: UUID) -> RoutineDB?
    func doneTodayRoutine(_ routine: RoutineDB)
    func isDoneDisabled(routineDB: RoutineDB) -> Bool
}

final class RoutineUseCase: RoutineUseCaseProtocol {
    
    private let routineRepository: RoutineRepositoryProtocol
    private let dateManager = DateManager.shared
    
    init(routineRepository: RoutineRepositoryProtocol) {
        self.routineRepository = routineRepository
    }
    
    func saveRoutine(_ routine: RoutineDB) {
        if routine.routineItems!.isEmpty {
            let routineitem = createRoutineItems(routine)
            routine.routineItems?.append(contentsOf: routineitem)
            
            routineitem.forEach {
                print(dateManager.getDateString(date: $0.date))
            }
        }
        
        routineRepository.addRoutine(routine)
    }
    
    func deleteRoutine(_ routine: RoutineDB) {
        routineRepository.deleteRoutine(routine)
    }
    
    func fetchRoutine(_ routineID: UUID) -> RoutineDB? {
        guard let routine = routineRepository.fetchRoutine(routineID) else { return nil }
        
        routine.routineItems?.sort { $0.date < $1.date }
        
        return routine
    }
    
    func isDoneDisabled(routineDB: RoutineDB) -> Bool {
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
    
    /// 완료 후 1일 추가
    func doneTodayRoutine(_ routineDB: RoutineDB) {
        
        let routineItem = routineDB.routineItems?.first {
            dateManager.getDateString(date: $0.date) == dateManager.getDateString(date: Date())
        }
        
        routineItem?.isDone = true
        
        guard let lastRoutineDate = routineDB.routineItems?.last?.date else { return }
        let nextDate = lastRoutineDate
        let repeatDays = routineDB.repeatDays ?? []
        let repeatInterval = routineDB.repeatInterval
        
        if let nextRoutineDate = getNextRoutineDate(from: nextDate,
                                                    repeatDays: repeatDays, repeatInterval: repeatInterval) {
            let newRoutineItem = RoutineItemDB(date: nextRoutineDate,
                                               isDone: false)
            routineDB.routineItems?.append(newRoutineItem)
        }
        
        routineRepository.addRoutine(routineDB)
        
    }
    
    /// 초기 생성시 루틴 7개 추가
    private func createRoutineItems(_ routineDB: RoutineDB) -> [RoutineItemDB] {
        var nextDate = Date()
        let repeatDays = routineDB.repeatDays ?? []
        var newRoutineItems: [RoutineItemDB] = []
        
        if let todayWeekday = Day(rawValue: Calendar.current.component(.weekday, from: nextDate)),
           repeatDays.contains(todayWeekday) {
            newRoutineItems.append(RoutineItemDB(date: nextDate, isDone: false))
        }
        
        for _ in 0..<7 {
            if let nextRoutineDate = getNextRoutineDate(from: nextDate, repeatDays: repeatDays) {
                let newRoutineItem = RoutineItemDB(date: nextRoutineDate, isDone: false)
                newRoutineItems.append(newRoutineItem)
                nextDate = nextRoutineDate
            } else {
                break
            }
        }
        
        return newRoutineItems
    }
    
    /// 다음 루틴은 일주일 내부에서 추가하는 방식
    private func getNextRoutineDate(from date: Date,
                                    repeatDays: Set<Day>) -> Date? {
        let calendar = Calendar.current
        
        var nextDate = date
        
        for _ in 0..<7 {
            nextDate = calendar.date(byAdding: .day,
                                     value: 1,
                                     to: nextDate) ?? nextDate
            let nextWeekday = calendar.component(.weekday,
                                                 from: nextDate)
            guard let day = Day(rawValue: nextWeekday) else { return nil }
            
            if repeatDays.contains(day) {
                return nextDate
            }
        }
        return nil
    }
    
    /// 다음 루틴은 repeatInterval주 후에 나오는 루틴
    private func getNextRoutineDate(from date: Date,
                                    repeatDays: Set<Day>,
                                    repeatInterval: Int) -> Date? {
        let calendar = Calendar.current
        
        var nextDate = calendar.date(byAdding: .day,
                                     value: 7 * repeatInterval,
                                     to: date) ?? date
        
        for _ in 0..<7 {
            nextDate = calendar.date(byAdding: .day,
                                     value: 1,
                                     to: nextDate) ?? nextDate
            let nextWeekday = calendar.component(.weekday,
                                                 from: nextDate)
            guard let day = Day(rawValue: nextWeekday) else { return nil }
            
            if repeatDays.contains(day) {
                return nextDate
            }
        }
        return nil
    }
    
}

