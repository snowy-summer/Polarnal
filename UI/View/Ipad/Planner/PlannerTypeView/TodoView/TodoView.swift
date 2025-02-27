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
        
        GeometryReader { geometry in
            let availableWidth = geometry.size.width
#if os(macOS)
            let columnCount = max(1, Int(availableWidth / 400))
#else
            let columnCount = 3
#endif
            let columns = Array(repeating: gridItems,
                                count: columnCount)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(todoFolderList,
                            id: \.id) { todoFolder in
                        TodoCell(todoFolder: todoFolder)
                            .background(Color.customGray6)
                            .frame(height: 400)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 5, x: 2, y:2)
                            .contextMenu {
                                Button(role: .destructive, action: {
                                    viewModel.apply(.deleteTodoFolder(todoFolder))
                                }) {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .padding()
                    }
                    
                }
            }
        }
        
        .onAppear {
            let repository = TodoRepository(modelContext: modelContext)
            let useCase = TodoUseCase(todoRepository: repository)
            viewModel.apply(.ingectDependencies(useCase: useCase))
        }
    }
}

#Preview(body: {
    TodoView()
})
