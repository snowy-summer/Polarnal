//
//  TabTye.swift
//  MacPolarnal
//
//  Created by 최승범 on 2/6/25.
//

import Foundation

enum TabType: CaseIterable {
    case planner
    case diary
//    case travelPlanner
    case setting
    
    var iconText: String {
        switch self {
        case .planner:
            return "calendar"
            
        case .diary:
            return "book.closed.fill"
            
//        case .travelPlanner:
//            return "airplane.departure"
            
        case .setting:
            return "gearshape.fill"
        }
        
    }
}
