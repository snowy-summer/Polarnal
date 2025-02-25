//
//  TravelTodoCell.swift
//  Polarnal
//
//  Created by 최승범 on 12/17/24.
//
#if os(iOS)
import Foundation
import SwiftUI
import SwiftData

struct TravelTodoCell: View {
    @ObservedObject var viewModel: TravelTodoCellViewModel
    
    init(todo: TravelTodoDB) {
        self.viewModel = TravelTodoCellViewModel(todo: todo)
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

#endif
