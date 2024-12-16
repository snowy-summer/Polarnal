//
//  TravelTicketType.swift
//  Polarnal
//
//  Created by 최승범 on 12/16/24.
//

import Foundation

enum TravelTicketType: String, CaseIterable {
    case hotel
    case flight
    case transportation
    case museumAndGallery
    case amusementPark
    case touristAttractions
    case performance
    case experiences
    case events
    case dining

    var title: String {
        switch self {
        case .hotel:
            return "숙소"
        case .flight:
            return "비행기"
        case .transportation:
            return "교통"
        case .museumAndGallery:
            return "박물관 & 미술관"
        case .amusementPark:
            return "유원지"
        case .touristAttractions:
            return "관광지"
        case .performance:
            return "공연"
        case .experiences:
            return "체험 활동"
        case .events:
            return "이벤트"
        case .dining:
            return "식사"
        }
    }
}
