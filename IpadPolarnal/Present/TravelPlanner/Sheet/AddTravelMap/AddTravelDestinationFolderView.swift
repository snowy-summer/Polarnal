//
//  AddTravelDestinationFolderView.swift
//  Polarnal
//
//  Created by 최승범 on 1/4/25.
//
#if os(iOS)
import SwiftUI

struct AddTravelDestinationFolderView: View {
    @Environment(\.modelContext) var modelContext
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
                    .background(Color.customGray6)
                    .cornerRadius(8)
                    .padding(.horizontal, 40)
            }
            .padding(.horizontal, 40)
            .padding(.top, 40)
            .padding(.bottom, 20)
            
            
            ColorPalettePartView(selctedColor: $viewModel.folderColor)
                .background(Color.customGray5)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding(.horizontal,40)
            
        }
        .padding(.bottom, 40)
        .navigationTitle("카테고리 생성")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext))
        }
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
                    viewModel.apply(.saveFolder)
                    dismiss()
                }) {
                    Text("저장")
                }
            }
        }
    }
}

#Preview {
    AddTravelDestinationFolderView(viewModel: AddTravelDestinationFolderViewModel(folder: nil,travelID: UUID()))
}
#endif
