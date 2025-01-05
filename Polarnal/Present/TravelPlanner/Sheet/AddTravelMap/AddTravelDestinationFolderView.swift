//
//  AddTravelDestinationFolderView.swift
//  Polarnal
//
//  Created by 최승범 on 1/4/25.
//

import SwiftUI

struct AddTravelDestinationFolderView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AddTravelDestinationFolderViewModel
    
    var body: some View {
        VStack {
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 100, height: 100)
                    .foregroundStyle(viewModel.folderColor)
                
                TextField("그룹 이름", text: $viewModel.folderTitle)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 40)
            }
            .padding(.horizontal, 40)
            .padding(.top, 40)
            .padding(.bottom, 20)
            
            
            ColorPalettePartView(selctedColor: $viewModel.folderColor)
                .background(Color(UIColor.systemGray5))
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
    AddTravelDestinationFolderView(viewModel: AddTravelDestinationFolderViewModel(folder: nil))
}
