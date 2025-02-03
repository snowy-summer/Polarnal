//
//  View+Extension.swift
//  Polarnal
//
//  Created by 최승범 on 1/19/25.
//

import SwiftUI

#if os(iOS)
import UIKit
typealias BezierPath = UIBezierPath
typealias RectCorner = UIRectCorner
#elseif os(macOS)
import AppKit
typealias BezierPath = NSBezierPath
struct RectCorner: OptionSet {
    let rawValue: Int

    static let topLeft     = RectCorner(rawValue: 1 << 0)
    static let topRight    = RectCorner(rawValue: 1 << 1)
    static let bottomLeft  = RectCorner(rawValue: 1 << 2)
    static let bottomRight = RectCorner(rawValue: 1 << 3)
    static let allCorners: RectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]
}
#endif

// MARK: - View Extension
extension View {
    func customCornerRadius(_ radius: CGFloat, corners: RectCorner) -> some View {
        clipShape(CustomCornerShape(radius: radius, corners: corners))
    }
}

// MARK: - Custom Corner Shape
struct CustomCornerShape: Shape {
    var radius: CGFloat
    var corners: RectCorner

    func path(in rect: CGRect) -> Path {
        #if os(iOS)
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
        
        #elseif os(macOS)
        let path = NSBezierPath(roundedRect: rect, corners: corners, radius: radius)
        return Path(path.cgPath)
        #endif
    }
}

#if os(macOS)
extension NSBezierPath {
    convenience init(roundedRect rect: CGRect, corners: RectCorner, radius: CGFloat) {
        self.init()
        
        let maxX = rect.maxX
        let maxY = rect.maxY
        let minX = rect.minX
        let minY = rect.minY

        move(to: CGPoint(x: minX, y: minY + (corners.contains(.bottomLeft) ? radius : 0)))

        if corners.contains(.bottomLeft) {
            appendArc(withCenter: CGPoint(x: minX + radius, y: minY + radius),
                      radius: radius,
                      startAngle: 180,
                      endAngle: 270,
                      clockwise: false)
        } else {
            line(to: CGPoint(x: minX, y: minY))
        }

        line(to: CGPoint(x: maxX - (corners.contains(.bottomRight) ? radius : 0), y: minY))

        if corners.contains(.bottomRight) {
            appendArc(withCenter: CGPoint(x: maxX - radius, y: minY + radius),
                      radius: radius,
                      startAngle: 270,
                      endAngle: 360,
                      clockwise: false)
        } else {
            line(to: CGPoint(x: maxX, y: minY))
        }

        line(to: CGPoint(x: maxX, y: maxY - (corners.contains(.topRight) ? radius : 0)))

        if corners.contains(.topRight) {
            appendArc(withCenter: CGPoint(x: maxX - radius, y: maxY - radius),
                      radius: radius,
                      startAngle: 0,
                      endAngle: 90,
                      clockwise: false)
        } else {
            line(to: CGPoint(x: maxX, y: maxY))
        }

        line(to: CGPoint(x: minX + (corners.contains(.topLeft) ? radius : 0), y: maxY))

        if corners.contains(.topLeft) {
            appendArc(withCenter: CGPoint(x: minX + radius, y: maxY - radius),
                      radius: radius,
                      startAngle: 90,
                      endAngle: 180,
                      clockwise: false)
        } else {
            line(to: CGPoint(x: minX, y: maxY))
        }

        close()
    }
    
    var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        
        for i in 0..<elementCount {
            let type = element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo:
                path.move(to: points[0])
            case .lineTo:
                path.addLine(to: points[0])
            case .curveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath:
                path.closeSubpath()
            @unknown default:
                break
            }
        }
        return path
    }
}
#endif
