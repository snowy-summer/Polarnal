//
//  TravelDocumentType.swift
//  Polarnal
//
//  Created by 최승범 on 12/23/24.
//

import Foundation

enum TravelDocumentType: String, CaseIterable {
    case flight
    case hotel
    case transportation
    case information
    case ticket
    case other
    
    var text: String {
        switch self {
        case .flight:
            return "항공"
            
        case .hotel:
            return "숙소"
            
        case .transportation:
            return "교통 패스"
            
        case .information:
            return "정보"
            
        case .ticket:
            return "티켓"
            
        case .other:
            return "기타"
        }
    }
    
    var icon: String {
        switch self {
        case .hotel:
            return "house.fill"
            
        case .flight:
            return "airplane"
            
        case .transportation:
            return "car.fill"
            
        case .information:
            return "info.circle.fill"
            
        case .ticket:
            return "ticket.fill"

        case .other:
            return "questionmark.circle.fill"
        }
    }
}
