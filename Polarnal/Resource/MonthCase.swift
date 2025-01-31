//
//  MonthCase.swift
//  Polarnal
//
//  Created by 최승범 on 1/31/25.
//

import Foundation

enum MonthCase: Int {
    case January = 1
    case February
    case March
    case April
    case May
    case June
    case July
    case August
    case September
    case October
    case November
    case December
    
    var shortName: LocalizedStringKey {
        switch self {
        case .January: return "Jan"
        case .February: return "Feb"
        case .March: return "Mar"
        case .April: return "Apr"
        case .May: return "May"
        case .June: return "Jun"
        case .July: return "Jul"
        case .August: return "Aug"
        case .September: return "Sep"
        case .October: return "Oct"
        case .November: return "Nov"
        case .December: return "Dec"
        }
    }
}
