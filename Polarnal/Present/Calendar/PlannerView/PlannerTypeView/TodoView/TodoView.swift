//
//  TodoView.swift
//  Polarnal
//
//  Created by 최승범 on 12/12/24.
//

import SwiftUI

struct TodoView: View {
    
    private let gridItems = GridItem(.flexible(), spacing: 16)
    let a = [1,2,3]
    var body: some View {
        ScrollView {
            let columns = Array(repeating: gridItems,
                                count: 2)
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(a,id: \.self) { _ in
                    TodoFolderCell()
                        .background(Color(uiColor: .systemGray5))
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(radius: 5, x: 2, y:2)
                        .contextMenu {
                            Button(role: .destructive, action: {
                                //                                viewModel.apply(.deleteDDay(dday))
                            }) {
                                Label("삭제", systemImage: "trash")
                            }
                            
                            Button(action: {
                                //                                viewModel.apply(.deleteDDay(dday))
                            }) {
                                Label("초기화", systemImage: "trash")
                            }
                        }
                        .onTapGesture {
                            //                            viewModel.apply(.showEditView(dday))
                        }
                        .padding()
                }
                
            }
            
        }
    }
}
#Preview(body: {
    TodoView()
})

struct TodoFolderCell: View {
    var body: some View {
        
        VStack {
            HStack {
                Text("개인적인 할일")
                    .font(.title)
                    .bold()
                    .padding()
                    .padding(.leading, 20)
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
