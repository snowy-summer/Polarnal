//
//  Color+Extension.swift
//  MacPolarnal
//
//  Created by 최승범 on 2/4/25.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
    
    func toHex() -> String? {
#if os(macOS)
        guard let color = NSColor(self).usingColorSpace(.sRGB) else { return nil }
#else
        let color = UIColor(self)
#endif
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
#if os(macOS)
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
#else
        guard color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
#endif
        
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
//        let a = Int(alpha * 255)
        
        // RGBA 형식으로 반환 (필요시 #RRGGBB로 수정 가능)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}
