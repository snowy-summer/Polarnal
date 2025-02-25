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

#if os(macOS)
            let colorRectangleSize: CGFloat = 24
            let radius: CGFloat = 4
#else
            let colorRectangleSize: CGFloat = 32
            let radius: CGFloat = 8
#endif
    
    init(todoFolder: TodoFolderDB, animation: Namespace.ID) {
        self._viewModel = StateObject(wrappedValue: TodoFolderCellViewModel(folder: todoFolder)) 
        self.animation = animation
    }
    
    var body: some View {
        
        VStack {
            HStack {
                RoundedRectangle(cornerRadius: radius)
                    .frame(width: colorRectangleSize,
                           height: colorRectangleSize)
                    .foregroundStyle(Color(hex: viewModel.todofolder.colorCode))
                    .padding(.leading, 20)
                
                Text(viewModel.todofolder.title)
                    .font(.title2)
                    .bold()
                    .padding()
            
                Spacer()
                
                Button(action: {
                    viewModel.apply(.addTodo)
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .bold()
                        .foregroundColor(.gray)
                }
                .buttonStyle(.plain)
                .padding()
                
            }
            
            Divider()
            
//            List {
//                ForEach(viewModel.todoList, id: \.id) { todo in
//                    TodoFolderContentCell(todo: todo)
//                        .listRowSeparator(.hidden)
//                        .listRowBackground(Color.customGray5)
//                }
//            }
//            .scrollContentBackground(.hidden)
//            .listStyle(.plain)
            List {
                ForEach(viewModel.todoList, id: \.id) { todo in
                    ExpandedTodoCell(todo: todo)
                        .listStyle(PlainListStyle())
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.customGray6)
                        .swipeActions(edge: .trailing,
                                      allowsFullSwipe: false) {
                            Button(role: .destructive, action: {
                                viewModel.apply(.deleteTodo(todo))
                            }, label: {
                                Label("삭제", systemImage: "trash")
                            })
                            
                        }
                    
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
            }
            
        }
        .matchedGeometryEffect(id: viewModel.todofolder.id, in: animation)
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext))
            viewModel.apply(.viewSetting)
        }
    }
}

struct TodoFolderContentCell: View {
    
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
