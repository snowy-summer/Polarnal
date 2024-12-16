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
    case culturalActivities
    case tips
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
        case .culturalActivities:
            return "문화생활"
        case .tips:
            return "팁"
        case .extrafee:
            return "추가 비용"
        case .other:
            return "기타"
        }
    }
}
