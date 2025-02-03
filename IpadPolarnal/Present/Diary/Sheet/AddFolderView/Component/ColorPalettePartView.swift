//
//  ColorPalettePartView.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI

struct ColorPalettePartView: View {
    
    @Binding var selctedColor: Color

    let columns = [
        GridItem(.adaptive(minimum: 50))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(ColorPalette.allCases, id: \.self) { value in
                    Circle()
                        .fill(value.color)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Circle()
                                .stroke(Color(uiColor: .gray), lineWidth: selctedColor == value.color ? 4 : 0)
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
