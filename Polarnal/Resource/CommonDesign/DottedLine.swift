//
//  DottedLine.swift
//  Polarnal
//
//  Created by 최승범 on 12/18/24.
//

import SwiftUI

struct DottedLine: Shape {
    var isVertical: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        if !isVertical {
            path.move(to: CGPoint(x: rect.minX, y: rect.minY)) // 시작점
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY)) // 끝점
        } else {
            path.move(to: CGPoint(x: rect.minX, y: rect.minY)) // 시작점
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY)) // 끝점
        }
        return path
    }
}
