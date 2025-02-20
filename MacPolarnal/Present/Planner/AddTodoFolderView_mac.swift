//
//  AddTodoFolderView.swift
//  MacPolarnal
//
//  Created by 최승범 on 2/6/25.
//

#if os(macOS)
import SwiftUI

struct AddTodoFolderView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @ObservedObject var viewModel: AddTodoFolderViewModel
    
    var body: some View {
        VStack {
            Text("New Todo")
                .font(.headline)
                .padding(.bottom, 10)
            
            TextField("Todo Name", text: $viewModel.todoFolderTitle)
                .font(.title3)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 20)
            
            ColorPalettePartView(selctedColor: $viewModel.todoFolderColor)
                .background(Color.customGray6)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Divider()
            
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
        .padding()
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext))
        }
    }
}
#endif
