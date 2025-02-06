//
//  AddDDayCellType.swift
//  MacPolarnal
//
//  Created by 최승범 on 2/6/25.
//

import Foundation

enum AddDDayCellType: CaseIterable {
    case plusOrMinus
    case category
    case startDay
    case goalDay
    
    var text: String {
        switch self {
        case .plusOrMinus:
            return "종류"
            
        case .category:
            return "카테고리"
            
        case .startDay:
            return "시작 날짜"
            
        case .goalDay:
            return "목표 날짜"
        }
    }
    
    var icon: String {
        switch self {
        case .plusOrMinus:
            return "star.fill"
            
        case .category:
            return "star.fill"
            
        case .startDay:
            return "star.fill"
            
        case .goalDay:
            return "star.fill"
        }
    }
}

