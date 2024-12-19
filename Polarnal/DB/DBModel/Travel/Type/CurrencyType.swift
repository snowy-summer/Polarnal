//
//  CurrencyType.swift
//  Polarnal
//
//  Created by 최승범 on 12/19/24.
//

import Foundation

enum CurrencyType: String, CaseIterable {
    case KRW = "KRW"
    case USD = "USD"
    case JPY = "JPY(100)"
    case CNH = "CNH"
    case EUR = "EUR"
    case THB = "THB"
    case GBP = "GBP"
    case AUD = "AUD"
    case CAD = "CAD"
    case CHF = "CHF"
    case INR = "INR"
    case MXN = "MXN"
    case ZAR = "ZAR"
    case SGD = "SGD"
    case BRL = "BRL"
    case MYR = "MYR"

    var symbol: String {
        switch self {
        case .KRW:
            return "₩ "
        case .USD:
            return "$ "
        case .JPY:
            return "￥ "
        case .CNH:
            return "CNH ￥ "
        case .EUR:
            return "€ "
        case .THB:
            return "฿ "
        case .GBP:
            return "£ "
        case .AUD:
            return "A$ "
        case .CAD:
            return "CA$ "
        case .CHF:
            return "CHF "
        case .INR:
            return "₹ "
        case .MXN:
            return "$ "
        case .ZAR:
            return "R "
        case .SGD:
            return "S$ "
        case .BRL:
            return "R$ "
        case .MYR:
            return "RM "
        }
    }

    var text: String {
        switch self {
        case .KRW:
            return "원"
        case .USD:
            return "달러"
        case .JPY:
            return "엔"
        case .CNH:
            return "위안"
        case .EUR:
            return "유로"
        case .THB:
            return "바트"
        case .GBP:
            return "파운드"
        case .AUD:
            return "호주 달러"
        case .CAD:
            return "캐나다 달러"
        case .CHF:
            return "스위스 프랑"
        case .INR:
            return "루피"
        case .MXN:
            return "페소"
        case .ZAR:
            return "랜드"
        case .SGD:
            return "싱가포르 달러"
        case .BRL:
            return "헤알"
        case .MYR:
            return "링깃"
        }
    }
}
