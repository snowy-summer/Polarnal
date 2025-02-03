//
//  ColorPalette.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI

enum ColorPalette: String, CaseIterable {
    case red, orange, yellow, green, blue, cyan, indigo, pink, purple, brown, gray, secondary, mint, teal, white
    
    var color: Color {
        switch self {
        case .red:
            return .red
            
        case .orange:
            return .orange
            
        case .yellow:
            return .yellow
            
        case .green:
            return .green
            
        case .blue:
            return .blue
            
        case .cyan:
            return .cyan
            
        case .indigo:
            return .indigo
            
        case .pink:
            return .pink
            
        case .purple:
            return .purple
            
        case .brown:
            return .brown
            
        case .gray:
            return .gray
            
        case .secondary:
            return .secondary
            
        case .mint:
            return .mint
            
        case .teal:
            return .teal
            
        case .white:
            return .white
        }
    }
}
