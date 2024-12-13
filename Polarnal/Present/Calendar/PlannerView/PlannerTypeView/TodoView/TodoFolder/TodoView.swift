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
    @Namespace private var animation
    
    private let gridItems = GridItem(.flexible(), spacing: 16)
    
    var body: some View {
        
        ZStack {
            if let folder = viewModel.selectedFolder {
                ExpandedFolderView(todoFolder: folder,
                                   animation: animation) {
                    withAnimation {
                        viewModel.selectedFolder = nil
                    }
                }
            } else {
                ScrollView {
                    let columns = Array(repeating: gridItems,
                                        count: 2)
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(todoFolderList,
                                id: \.id) { todoFolder in
                            TodoFolderCell(todoFolder: todoFolder,
                                           animation: animation)
                            .background(Color(uiColor: .systemGray5))
                            .frame(height: 400)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            .shadow(radius: 5, x: 2, y:2)
                            .contextMenu {
                                Button(role: .destructive, action: {
                                    viewModel.apply(.deleteTodoFolder(todoFolder))
                                }) {
                                    Label("Todo 폴더 삭제", systemImage: "trash")
                                }
                            }
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    viewModel.selectedFolder = todoFolder
                                }
                            }
                            .padding()
                        }
                        
                    }
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
