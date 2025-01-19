//
//  View+Extension.swift
//  Polarnal
//
//  Created by 최승범 on 1/19/25.
//

import SwiftUI

extension View {
    
    func customCornerRadius(_ radius: CGFloat,
                            corners: UIRectCorner) -> some View {
        self.clipShape(CustomCornerShape(radius: radius,
                                         corners: corners))
    }
    /*
     사용방법
     원하는 코너를 선택해서 변형이 가능
     .customCornerRadius(12, corners: [.bottomLeft, .bottomRight])
     */
    
}

struct CustomCornerShape: Shape {
    
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
    
}
