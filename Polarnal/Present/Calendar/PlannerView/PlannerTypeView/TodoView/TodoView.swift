//
//  TodoView.swift
//  Polarnal
//
//  Created by 최승범 on 12/12/24.
//

import SwiftUI
import SwiftData

struct TodoView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject var viewModel: TodoViewModel = TodoViewModel()
    @Query var todoFolderList: [TodoFolderDB]
    
    private let gridItems = GridItem(.flexible(), spacing: 16)
    
    var body: some View {
        ScrollView {
            let columns = Array(repeating: gridItems,
                                count: 2)
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(todoFolderList,
                        id: \.id) { todoFolder in
                    TodoFolderCell(todofolder: todoFolder)
                        .background(Color(uiColor: .systemGray5))
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(radius: 5, x: 2, y:2)
                        .contextMenu {
                            Button(role: .destructive, action: {
                                viewModel.apply(.deleteTodoFolder(todoFolder))
                            }) {
                                Label("Todo 폴더 삭제", systemImage: "trash")
                            }
                            
                            Button(action: {
                                //                                viewModel.apply(.deleteDDay(dday))
                            }) {
                                Label("Todo 항목 초기화", systemImage: "trash")
                            }
                        }
                        .onTapGesture {
                            //                            viewModel.apply(.showEditView(dday))
                        }
                        .padding()
                }
                
            }
            
        }
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext))
        }
    }
}
#Preview(body: {
    TodoView()
})

struct TodoFolderCell: View {
    
    let todofolder: TodoFolderDB
    
    var body: some View {
        
        VStack {
            HStack {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 44, height: 44)
                    .foregroundStyle(todofolder.color.convertToColor())
                    .padding(.leading, 20)
                
                Text(todofolder.title)
                    .font(.title)
                    .bold()
                    .padding()
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.black)
                        .bold()
                }
                .padding()
                
            }
            
            Divider()
            
            List {
                TodoCell()
                    .listRowSeparator(.hidden)
                TodoCell()
                    .listRowSeparator(.hidden)
                TodoCell()
                    .listRowSeparator(.hidden)
                TodoCell()
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            
        }
    }
}

struct TodoCell: View {
    
    let aa = false
    
    var body: some View {
        Button(action: {
            
        }, label: {
            HStack {
                if aa {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                } else {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                
                Text("장보기")
                    .font(.title3)
                    .bold()
                    .padding(.horizontal)
            }
            .padding()
        })
    }
}
