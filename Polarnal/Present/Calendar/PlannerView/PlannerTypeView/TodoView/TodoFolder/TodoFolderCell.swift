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
    @Query var todoList: [TodoDB]
    @ObservedObject var viewModel: TodoFolderCellViewModel
    let animation: Namespace.ID
    
    init(viewModel: TodoFolderCellViewModel, animation: Namespace.ID) {
        self.viewModel = viewModel
        let folderID = viewModel.todofolder.id
        _todoList = Query(filter: #Predicate<TodoDB> { $0.folder.id == folderID })
        self.animation = animation
    }
    
    var body: some View {
        
        VStack {
            HStack {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 44, height: 44)
                    .foregroundStyle(viewModel.todofolder.color.convertToColor())
                    .padding(.leading, 20)
                
                Text(viewModel.todofolder.title)
                    .font(.title)
                    .bold()
                    .padding()
                
                Spacer()
                
                Button {
                    // Todo 목록 만들기
                    viewModel.apply(.addTodo)
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.black)
                        .bold()
                }
                .padding()
                
            }
            
            Divider()
            
            List {
                ForEach(todoList, id: \.id) { todo in
                    TodoCell(todo: todo)
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
            }
            .listStyle(.plain)
            
        }
        .matchedGeometryEffect(id: viewModel.todofolder.id, in: animation)
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext))
        }
    }
}
