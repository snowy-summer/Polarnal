//
//  ColorPalettePartView.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI

struct ColorPalettePartView: View {
    
    @Binding var selctedColor: Color

#if os(macOS)
    private let circleFrame: CGFloat = 32
    private let spacing: CGFloat = 32
#elseif os(iOS)
    private let circleFrame: CGFloat = 50
    private let spacing: CGFloat = 50
#endif

    var body: some View {
        let columns = [
            GridItem(.adaptive(minimum: spacing))
        ]
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(ColorPalette.allCases, id: \.self) { value in
                    Circle()
                        .fill(value.color)
                        .frame(width: circleFrame,
                               height: circleFrame)
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: selctedColor == value.color ? 4 : 0)
                        )
                        .onTapGesture {
                            selctedColor = value.color
                        }
                }
                
                ColorPicker("", selection: $selctedColor)
                    .labelsHidden()
                    .frame(width: 50, height: 50)
            }
            .padding()
        }
    }
}

#Preview {
    ColorPalettePartView(selctedColor: .constant(.blue))
}
