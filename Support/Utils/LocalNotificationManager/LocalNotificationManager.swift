//
//  LocalNotificationManager.swift
//  CoreBrick
//
//  Created by 최승범 on 2/28/25.
//

import SwiftUI
import UserNotifications

final class LocalNotificationManager {
    static let shared = LocalNotificationManager()
    private init() {}
    
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .notDetermined else {
                LogManager.log("알림 권한이 이미 설정됨: \(settings.authorizationStatus)")
                return
            }
            
            let options: UNAuthorizationOptions = [.alert, .sound, .badge]
            center.requestAuthorization(options: options) { (success, error) in
                if let error = error {
                    LogManager.log("알림 권한 요청 실패: \(error.localizedDescription)")
                } else {
                    LogManager.log("알림설정이 완료되었습니다")
                }
            }
        }
    }
    
    enum TriggerType: String {
        case calendar = "calendar"
        
        var trigger: UNNotificationTrigger {
            switch self {
            case .calendar:
                let dateComponents = DateComponents(hour: 20, minute: 26, weekday: 2)
                return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
            }
        }
    }
    
    func scheduleWeeklyNotification(identifier: String,
                                    title: String,
                                    body: String,
                                    time: Date,
                                    weekDay: Int) {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings {[weak self] settings in
            guard let self else { return }
            guard settings.authorizationStatus == .authorized else {
                LogManager.log("알림 권한이 허용되지 않음")
                return
            }
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
//            content.badge = 1
            
            let calendar = Calendar.current
            var nextDateComponents = calendar.dateComponents([.hour, .minute], from: time)
            nextDateComponents.weekday = weekDay
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: nextDateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    LogManager.log("알림 등록 실패: \(error.localizedDescription)")
                } else {
                    LogManager.log("알림 등록 성공: \(identifier)")
                }
            }
        }
    }

    /// 현재 날짜로부터 가장 가까운 특정 요일의 날짜 반환
    private func getNextWeekdayDate(weekday: Int, time: Date) -> Date? {
        let calendar = Calendar.current
        let now = Date()
        
        var components = calendar.dateComponents([.hour, .minute], from: time)
        components.weekday = weekday

        for i in 0..<7 {
            if let nextDate = calendar.date(byAdding: .day, value: i, to: now),
               calendar.component(.weekday, from: nextDate) == weekday {
                components.year = calendar.component(.year, from: nextDate)
                components.month = calendar.component(.month, from: nextDate)
                components.day = calendar.component(.day, from: nextDate)
                return calendar.date(from: components)
            }
        }
        
        return nil
    }
    
    func removeAllNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        LogManager.log("모든 예약된 알림 제거")
    }
    
    func removeNotification(identifier: String) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        LogManager.log("알림 제거됨: \(identifier)")
    }
}
