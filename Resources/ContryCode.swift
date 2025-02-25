//
//  ContryCode.swift
//  MacPolarnal
//
//  Created by 최승범 on 2/6/25.
//

import Foundation

enum ContryCode: String, CaseIterable {
    case korea = "ko"
    case america = "en"
    case japan = "ja"
    
    var title: String {
        switch self {
        case .korea:
            return "한국어"
        case .america:
            return "English"
        case .japan:
            return "日本語"
        }
    }
}
