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
    
    func scheduleNotification(identifier: String,
                              title: String,
                              body: String,
                              date: Date) {
        let center = UNUserNotificationCenter.current()
        
        // 권한 확인
        center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else {
                LogManager.log("알림 권한이 허용되지 않음")
                return
            }
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            content.badge = 1
            
            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    LogManager.log("알림 등록 실패: \(error.localizedDescription)")
                    print("알림 등록 실패: \(error.localizedDescription)")
                } else {
                    LogManager.log("알림 등록 성공: \(identifier)")
                }
            }
        }
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
