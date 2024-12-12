//
//  ExpendedTodoFolderCell.swift
//  Polarnal
//
//  Created by 최승범 on 12/12/24.
//

import SwiftUI
import SwiftData

struct ExpandedFolderView: View {
    
    @Environment(\.modelContext) var modelContext
    @ObservedObject var viewModel: TodoFolderCellViewModel
    @Query var todoList: [TodoDB]
    let animation: Namespace.ID
    let onClose: () -> Void
    
    init(viewModel: TodoFolderCellViewModel,
         animation: Namespace.ID,
         onClose: @escaping () -> Void) {
        self.viewModel = viewModel
        let folderID = viewModel.todofolder.id
        _todoList = Query(filter: #Predicate<TodoDB> { $0.folder.id == folderID })
        
        self.animation = animation
        self.onClose = onClose
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundColor(.gray)
                }
                .padding()
                Spacer()
                Text(viewModel.todofolder.title)
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Button(action: {
                    viewModel.apply(.addTodo)
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .bold()
                        .foregroundColor(.gray)
                }
                .padding()
                
            }
            
            Divider()
            
            List {
                ForEach(todoList, id: \.id) { todo in
                    ExpandedTodoCell(todo: todo)
                        .listRowSeparator(.hidden)
                        .swipeActions(edge: .trailing,
                                      allowsFullSwipe: false) {
                            Button(role: .destructive, action: {
                                viewModel.apply(.deleteTodo(todo))
                            }, label: {
                                Label("삭제", systemImage: "trash")
                            })
                            
                        }
                    
                }
                .listStyle(.plain)
            }
            
        }
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext))
        }
        .matchedGeometryEffect(id: viewModel.todofolder.id,
                               in: animation)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(radius: 10)
        .padding()
        
        //            Spacer()
        
        //        .background(Color.white.ignoresSafeArea())
    }
}

struct ExpandedTodoCell: View {
    @ObservedObject var viewModel: ExpandedTodoCellViewModel
    
    init(todo: TodoDB) {
        self.viewModel = ExpandedTodoCellViewModel(todo: todo)
    }
    
    var body: some View {
        Button(action: {
            
        }, label: {
            HStack {
                if viewModel.todo.isDone {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                } else {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                
                TextField("할일",text: $viewModel.todoContent)
                    .font(.title3)
                    .bold()
                    .padding(.horizontal)
            }
            .padding()
        })
    }
}

