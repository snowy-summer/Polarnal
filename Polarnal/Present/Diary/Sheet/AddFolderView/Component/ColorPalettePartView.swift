//
//  ColorPalettePartView.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI

struct ColorPalettePartView: View {
    
    @ObservedObject var viewModel: AddFolderViewModel
    
    init(viewModel: AddFolderViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
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
                                .stroke(Color(uiColor: .gray), lineWidth: viewModel.folderColor == value.color ? 4 : 0)
                        )
                        .onTapGesture {
                            viewModel.apply(.selectColor(value.color))
                        }
                }
                
                ColorPicker("", selection: $viewModel.folderColor)
                    .labelsHidden()
                    .frame(width: 50, height: 50)
            }
            .padding()
        }
    }
}

#Preview {
    ColorPalettePartView(viewModel: AddFolderViewModel(folder: nil))
}
