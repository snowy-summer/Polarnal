//
//  AddEventCellType.swift
//  MacPolarnal
//
//  Created by 최승범 on 2/6/25.
//

import Foundation

enum AddEventCellType: CaseIterable {
    case category
    case period
    case eventRepeat
    case settingDDay
    
    var text: String {
        switch self {
        case .category:
            return "카테고리"
            
        case .period:
            return "기간"
            
        case .eventRepeat:
            return "반복"
            
        case .settingDDay:
            return "D-Day 설정"
        }
    }
    
    var icon: String {
        switch self {
        case .category:
            return "star.fill"
            
        case .period:
            return "star.fill"
            
        case .eventRepeat:
            return "star.fill"
            
        case .settingDDay:
            return "star.fill"
        }
    }
}



