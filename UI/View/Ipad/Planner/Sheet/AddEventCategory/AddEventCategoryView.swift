//
//  AddEventCategoryView.swift
//  Polarnal
//
//  Created by 최승범 on 12/11/24.
//
#if os(iOS)
import SwiftUI

struct AddEventCategoryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AddEventCategoryViewModel
    
    var body: some View {
        VStack {
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 100, height: 100)
                    .foregroundStyle(viewModel.categoryColor)
                
                TextField("카테고리 이름", text: $viewModel.categoryTitle)
                    .padding()
                    .background(Color.customGray6)
                    .cornerRadius(8)
                    .padding(.horizontal, 40)
            }
            .padding(.horizontal, 40)
            .padding(.top, 40)
            .padding(.bottom, 20)
            
            
            ColorPalettePartView(selctedColor: $viewModel.categoryColor)
                .background(Color.customGray5)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding(.horizontal,40)
            
        }
        .padding(.bottom, 40)
        .navigationTitle("카테고리 생성")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Text("취소")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.apply(.saveCategory)
                    dismiss()
                }) {
                    Text("저장")
                }
            }
        }
    }
}

#Preview {
    AddEventCategoryView(viewModel: AddEventCategoryViewModel(eventCategory: nil))
}
#endif
