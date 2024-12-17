//
//  TravelTodoMiniView.swift
//  Polarnal
//
//  Created by 최승범 on 12/17/24.
//

import SwiftUI
import SwiftData

struct TravelTodoMiniView: View {
    
    @Environment(\.modelContext) var modelContext
    @StateObject var viewModel: TravelTodoMiniViewModel
    
    init(travel: TravelPlanDB) {
        self._viewModel = StateObject(wrappedValue: TravelTodoMiniViewModel(travel: travel))
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Todo")
                    .font(.title2)
                    .bold()
                Spacer()
                
                Button(action: {
                    viewModel.apply(.addTodo)
                }, label: {
                    Image(systemName: "plus")
                        .tint(.black)
                        .bold()
                })
            }
            .padding(.top)
            .padding(.horizontal)
            
            Divider()
            
            List {
                ForEach(viewModel.todoList, id: \.id) { todo in
                    TravelTodoCell(todo: todo)
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
            viewModel.apply(.viewSetting)
        }
    }
}
