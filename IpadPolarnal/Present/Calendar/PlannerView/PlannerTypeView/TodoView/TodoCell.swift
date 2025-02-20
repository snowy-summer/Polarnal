//
//  TodoCell.swift
//  Polarnal
//
//  Created by 최승범 on 2/20/25.
//

import SwiftUI
import SwiftData

struct TodoCell: View {
    
    @Environment(\.modelContext) var modelContext
    @StateObject var viewModel: TodoFolderCellViewModel
    
#if os(macOS)
    let colorRectangleSize: CGFloat = 24
    let radius: CGFloat = 4
#else
    let colorRectangleSize: CGFloat = 32
    let radius: CGFloat = 8
#endif
    
    init(todoFolder: TodoFolderDB) {
        self._viewModel = StateObject(wrappedValue: TodoFolderCellViewModel(folder: todoFolder))
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
            List {
                ForEach(viewModel.todoList, id: \.id) { todo in
                    TodoContentCell(todo: todo)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.customGray6)
                        .contextMenu {
                            Button(role: .destructive) {
                                viewModel.apply(.deleteTodo(todo))
                            } label: {
                                Label("삭제", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .trailing,
                                      allowsFullSwipe: false) {
                            Button(role: .destructive, action: {
                                viewModel.apply(.deleteTodo(todo))
                            }, label: {
                                Label("삭제", systemImage: "trash")
                            })
                            
                        }
                                      
                    
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            
        }
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext))
            viewModel.apply(.viewSetting)
        }
    }
}

struct TodoContentCell: View {
    @ObservedObject var viewModel: ExpandedTodoCellViewModel
    
    init(todo: TodoDB) {
        self.viewModel = ExpandedTodoCellViewModel(todo: todo)
    }
    
    var body: some View {
        HStack {
            Group {
                if viewModel.todo.isDone {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .foregroundStyle(.red)
                        .frame(width: 30, height: 30)
                } else {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .foregroundStyle(.blue)
                        .frame(width: 30, height: 30)
                }
            }
            .onTapGesture {
                viewModel.apply(.todoDoneToggle)
            }
            
            TextField("할일",text: $viewModel.todoContent)
                .font(.title3)
                .bold()
                .padding(.horizontal)
            
        }
        .padding()
    }
}
