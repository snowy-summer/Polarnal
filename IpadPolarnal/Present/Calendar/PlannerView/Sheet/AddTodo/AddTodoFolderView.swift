//
//  AddTodoFolderView.swift
//  Polarnal
//
//  Created by 최승범 on 12/12/24.
//
#if os(iOS)
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
            
        }
        .padding(.bottom, 40)
        .navigationTitle("Todo 폴더 생성")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Text("취소")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.apply(.saveTodoFolder)
                    dismiss()
                }) {
                    Text("저장")
                }
            }
        }
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext))
        }
    }
}

#Preview {
    AddTodoFolderView(viewModel: AddTodoFolderViewModel(todoFolder: nil))
}
#endif
