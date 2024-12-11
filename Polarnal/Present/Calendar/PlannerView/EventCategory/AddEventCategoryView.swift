//
//  AddEventCategoryView.swift
//  Polarnal
//
//  Created by 최승범 on 12/11/24.
//

import SwiftUI

struct AddEventCategoryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AddEventCategoryViewModel
    
    var body: some View {
        ScrollView {
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.blue)
                
                TextField("카테고리 이름", text: $viewModel.categoryTitle)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 40)
            }
            .padding(.horizontal, 40)
            .padding(.top, 40)
            .padding(.bottom, 20)
        }
        .navigationTitle("카테고리 생성")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("취소") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("저장") {
                    viewModel.apply(.addFolder)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddEventCategoryView(viewModel: AddEventCategoryViewModel(eventCategory: nil))
}
