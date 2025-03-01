//
//  AddRoutineViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 2/19/25.
//

import SwiftUI
import Combine
import SwiftData

final class AddRoutineViewModel: ViewModelProtocol {
    
    @Published var routineName: String
    @Published var repeatDays: Set<Day> = []
    @Published var repeatInterval: Int = 1
    @Published var startDate: Date = Date()
    @Published var routineColor: Color = .mint
    @Published var isPushEnabled: Bool = false
    @Published var notificationTime: Date = Date()
    var saveDisabled: Bool {
        if routineName.isEmpty { return true }
        if repeatDays.isEmpty { return true }
        return false
    }
    
    private var routineDB: RoutineDB?
    
    init(routine: RoutineDB?,
         notificationUseCase: RoutineNotificationUseCaseProtocol = RoutineNotificationUseCase()) {
        self.notificationUseCase = notificationUseCase
        if let routine {
            self.routineDB = routine
            routineName = routine.name
            repeatDays = routine.repeatDays ?? []
            repeatInterval = routine.repeatInterval
            startDate = routine.startDate
            routineColor = Color(hex: routine.colorCode)
            isPushEnabled = routine.isPushEnabled
            notificationTime = routine.pushTime ?? Date()
        } else {
            routineName = ""
            startDate = Date()
            repeatDays = []
            repeatInterval = 1
            routineColor = .mint
            isPushEnabled = false
            notificationTime = Date()
        }
    }
    
    enum Intent {
        case saveRoutine
        case ingectDependencies(RoutineUseCaseProtocol)
        
        case selectRepeatDay(Day)
        case selectInterval(Int)
    }
    
    private var useCase: RoutineUseCaseProtocol?
    private let notificationUseCase: RoutineNotificationUseCaseProtocol
    var cancellables = Set<AnyCancellable>()
    
    func apply(_ intent: Intent) {
        switch intent {
        case .saveRoutine:
            guard let hexCode = routineColor.toHex() else {
                LogManager.log("RoutineColor hex변환 실패")
                return
            }
            
            if routineDB != nil {
                routineDB?.name = routineName
                routineDB?.startDate = startDate
                routineDB?.repeatDays = repeatDays
                routineDB?.repeatInterval = repeatInterval
                routineDB?.colorCode = hexCode
                routineDB?.isPushEnabled = isPushEnabled
                routineDB?.pushTime = notificationTime
                
                if isPushEnabled {
                    notificationUseCase.scheduleRoutineNotification(for: routineDB!)
                }
                
                useCase?.saveRoutine(routineDB!)
            } else {
                let routine = RoutineDB(name: routineName,
                                        startDate: startDate,
                                        repeatDays: repeatDays,
                                        repeatInterval: repeatInterval,
                                        routineItems: [],
                                        colorCode: hexCode,
                                        isPushEnabled: isPushEnabled,
                                        pushTime: notificationTime)
                
                if isPushEnabled {
                    notificationUseCase.scheduleRoutineNotification(for: routine)
                }
                
                useCase?.saveRoutine(routine)
            }
            
        case .ingectDependencies(let useCase):
            self.useCase = useCase
            
        case .selectRepeatDay(let day):
            if repeatDays.contains(day) {
                repeatDays.remove(day)
            } else {
                repeatDays.insert(day)
            }
         
        case .selectInterval(let interval):
            repeatInterval = interval
        }
    }
    
    func isSelected(day: Day) -> Bool {
        repeatDays.contains(day)
    }
    
    func isSelected(interval: Int) -> Bool {
        repeatInterval == interval
    }
}
