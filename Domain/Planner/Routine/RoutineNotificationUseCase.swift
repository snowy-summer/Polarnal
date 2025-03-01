//
//  RoutineNotificationUseCase.swift
//  CoreBrick
//
//  Created by 최승범 on 3/1/25.
//

import Foundation

protocol RoutineNotificationUseCaseProtocol {
    func scheduleRoutineNotification(for routine: RoutineDB)
    func removeRoutineNotification(for routine: RoutineDB)
}

final class RoutineNotificationUseCase: RoutineNotificationUseCaseProtocol {
    
    private let notificationManager: LocalNotificationManager = .shared
    
    
    func scheduleRoutineNotification(for routine: RoutineDB) {
        guard let repeatDays = routine.repeatDays,
              let time = routine.pushTime else { return }
        
        for day in repeatDays {
            let identifier = "\(routine.id)" + "\(day.rawValue)"
            notificationManager.scheduleWeeklyNotification(identifier: identifier,
                                                           title: "Routine",
                                                           body:"check your \(routine.name)",
                                                           time: time,
                                                           weekDay: day.rawValue)
        }
        
    }
    
    func removeRoutineNotification(for routine: RoutineDB) {
        guard let repeatDays = routine.repeatDays,
              let time = routine.pushTime else { return }
        
        for day in repeatDays {
            let identifier = "\(routine.id)" + "\(day.rawValue)"
            notificationManager.removeNotification(identifier: identifier)
        }
    }
}
