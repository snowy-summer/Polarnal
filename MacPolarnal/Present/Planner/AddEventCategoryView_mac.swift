//
//  AddEventCategoryView.swift
//  MacPolarnal
//
//  Created by 최승범 on 2/6/25.
//

#if os(macOS)

import SwiftUI

struct AddEventCategoryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AddEventCategoryViewModel
    
    var body: some View {
        
        VStack {
            Text("New Category")
                .font(.headline)
                .padding(.bottom, 10)
            
            TextField("Category Name", text: $viewModel.categoryTitle)
                .font(.title3)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 20)
            
            ColorPalettePartView(selctedColor: $viewModel.categoryColor)
                .background(.ipadTabbar)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Divider()
            
            HStack {
                
                Button("Cancel") {
                    dismiss()
                }
                
                Spacer()
                
                Button("Add Folder") {
                    viewModel.apply(.saveCategory)
                    dismiss()
                }
                .disabled(viewModel.categoryTitle.isEmpty)
                
            }
            
        }
        .padding()
    }
}

#endif
