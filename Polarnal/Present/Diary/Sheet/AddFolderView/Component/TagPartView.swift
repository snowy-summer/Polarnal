//
//  TagPartView.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI

struct TagPartView: View {
    @ObservedObject var viewModel: AddFolderViewModel
    
    init(viewModel: AddFolderViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 100, height: 100)
                        .foregroundStyle(viewModel.folderColor)
                    
                    Image(systemName: viewModel.folderIcon.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.white)
                        .frame(width: 50, height: 50)
                }
                
                TextField("폴더 이름", text: $viewModel.folderTitle)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 40)
            }
            .padding(.horizontal, 40)
            .padding(.top, 40)
            .padding(.bottom, 20)
            
            Divider()
            
            HStack {
                TextField("태그 입력", text: $viewModel.newTagName)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
                
                Button {
                    viewModel.apply(.addTag)
                } label: {
                    Text("추가")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.black)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                }
                .padding(.leading, 20)
                
            }
            .padding(.horizontal, 40)
            .padding(.top, 40)
            .padding(.bottom, 20)
            
            TagCollectionView(viewModel: viewModel)
                .frame(maxWidth: .infinity)
                .frame(height: 400)
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            
        }
    }
}

#Preview {
    TagPartView(viewModel: AddFolderViewModel(folder: nil))
}
