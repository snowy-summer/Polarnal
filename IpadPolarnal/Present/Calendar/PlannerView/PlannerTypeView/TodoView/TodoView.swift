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
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewModel.apply(.clearSelectedFolder)
                    }
                }
            } else {
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
                                TodoFolderCell(todoFolder: todoFolder,
                                               animation: animation)
                                .background(Color.customGray5)
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
                                .onTapGesture {
                                    viewModel.apply(.clearSelectedFolder)
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        viewModel.apply(.selectFolder(todoFolder))
                                    }
                                }
                                .padding()
                            }
                            
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
