//
//  TravelCostType.swift
//  Polarnal
//
//  Created by 최승범 on 12/16/24.
//

import Foundation

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
            return "비행기"
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
}

