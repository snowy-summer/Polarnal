//
//  AddTodoFolderView.swift
//  MacPolarnal
//
//  Created by 최승범 on 2/6/25.
//

import SwiftUI

struct AddTodoFolderView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @ObservedObject var viewModel: AddTodoFolderViewModel
    
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(viewModel.todoFolderColor)
                
                TextField("Todo 폴더 이름", text: $viewModel.todoFolderTitle)
                    .padding()
                    .background(Color.customGray6)
                    .cornerRadius(8)
                    .padding(.horizontal, 40)
            }
            .padding(.horizontal, 40)
            .padding(.top, 40)
            .padding(.bottom, 20)
            
            
            ColorPalettePartView(selctedColor: $viewModel.todoFolderColor)
                .background(Color.customGray5)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding(.horizontal,40)
            
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                
                Spacer()
                
                Button("Save") {
                    viewModel.apply(.saveTodoFolder)
                    dismiss()
                }
                .disabled(viewModel.todoFolderTitle.isEmpty)
                
            }
            
        }
        .padding(.bottom, 40)
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext))
        }
    }
}
