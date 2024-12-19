//
//  TravelCostType.swift
//  Polarnal
//
//  Created by 최승범 on 12/16/24.
//

import SwiftUI

enum TravelCostType: String, CaseIterable {
    case hotel
    case meals
    case shopping
    case flight
    case transportation
    case activity
    case culturalActivities
    case gift
    case extrafee
    case other
    
    var title: String {
        switch self {
        case .hotel:
            return "숙소"
        case .meals:
            return "음식"
        case .shopping:
            return "쇼핑"
        case .flight:
            return "항공"
        case .transportation:
            return "교통비"
        case .activity:
            return "액티비티"
        case .culturalActivities:
            return "문화생활"
        case .gift:
            return "선물"
        case .extrafee:
            return "추가 비용"
        case .other:
            return "기타"
        }
    }
    
    var textIcon: String {
        switch self {
        case .hotel:
            return "🏠"
        case .meals:
            return "🍽️"
        case .shopping:
            return "🛍️"
        case .flight:
            return "✈️"
        case .transportation:
            return "🚋"
        case .activity:
            return "🎯"
        case .culturalActivities:
            return "🎬"
        case .gift:
            return "🎁"
        case .extrafee:
            return "💸"
        case .other:
            return "👾"
        }
    }
    
    var icon: String {
        switch self {
        case .hotel:
            return "house.fill"
        case .meals: 
            return "fork.knife"
        case .shopping: 
            return "cart.fill"
        case .flight: 
            return "airplane"
        case .transportation: 
            return "car.fill"
        case .activity:
            return "figure.skiing.downhill"
        case .culturalActivities:
            return "theatermasks.fill"
        case .gift:
            return "gift.fill"
        case .extrafee: 
            return "plus.circle.fill"
        case .other:
            return "questionmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .hotel:
            return Color(red: 0.60, green: 1.0, blue: 0.60) // 부드러운 파스텔 그린 (호텔)
        case .meals:
            return Color(red: 0.75, green: 0.89, blue: 0.72) // 파스텔 그린 (식사)
        case .shopping:
            return Color(red: 0.98, green: 0.74, blue: 0.55) // 파스텔 오렌지 (쇼핑)
        case .flight:
            return Color(red: 0.67, green: 0.88, blue: 0.98) // 파스텔 스카이 블루 (항공)
        case .transportation:
            return Color(red: 0.80, green: 0.80, blue: 0.80) // 파스텔 그레이 (교통)
        case .activity:
            return Color(red: 0.80, green: 0.70, blue: 0.90) // 파스텔 퍼플 (활동)
        case .culturalActivities:
            return Color(red: 1.00, green: 0.98, blue: 0.55) // 파스텔 옐로우 (문화활동)
        case .gift:
            return Color(red: 0.98, green: 0.82, blue: 0.87) // 파스텔 핑크 (선물)
        case .extrafee:
            return Color(red: 1.00, green: 0.60, blue: 0.60) // 파스텔 레드 (추가 요금)
        case .other:
            return Color(red: 0.80, green: 0.80, blue: 0.85) // 파스텔 그레이 (기타)
        }
    }
}

