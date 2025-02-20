//
//  TodoFolderCell.swift
//  Polarnal
//
//  Created by 최승범 on 12/12/24.
//

import SwiftUI
import SwiftData

struct TodoFolderCell: View {
    
    @Environment(\.modelContext) var modelContext
    @StateObject var viewModel: TodoFolderCellViewModel
    let animation: Namespace.ID
    
    init(todoFolder: TodoFolderDB, animation: Namespace.ID) {
        self._viewModel = StateObject(wrappedValue: TodoFolderCellViewModel(folder: todoFolder)) 
        self.animation = animation
    }
    
    var body: some View {
        
        VStack {
            HStack {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 44, height: 44)
                    .foregroundStyle(Color(hex: viewModel.todofolder.colorCode))
                    .padding(.leading, 20)
                
                Text(viewModel.todofolder.title)
                    .font(.title2)
                    .bold()
                    .padding()
            
                Spacer()
                
            }
            
            Divider()
            
            List {
                ForEach(viewModel.todoList, id: \.id) { todo in
                    TodoCell(todo: todo)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.customGray5)
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            
        }
        .matchedGeometryEffect(id: viewModel.todofolder.id, in: animation)
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext))
            viewModel.apply(.viewSetting)
        }
    }
}

struct TodoCell: View {
    
    let todo: TodoDB
    
    var body: some View {
        HStack {
            if todo.isDone {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .foregroundStyle(.red)
                    .frame(width: 24, height: 24)
            } else {
                Image(systemName: "circle.fill")
                    .resizable()
                    .foregroundStyle(.blue)
                    .frame(width: 24, height: 24)
            }
            
            Text(todo.content)
                .font(.title3)
                .bold()
                .padding(.horizontal)
        }
        .padding()
    }
}
