//
//  IconSelectPartView.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI

struct IconSelectPartView: View {
    
    @ObservedObject var viewModel: AddFolderViewModel
    
    init(viewModel: AddFolderViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    let columns = [
        GridItem(.adaptive(minimum: 66))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(DesignOfFolderIcon.allCases, id: \.self) { icon in
                    
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: icon.iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                        
                    }
                    .overlay(
                        Circle()
                            .stroke(Color(uiColor: .gray), lineWidth: viewModel.folderIcon == icon ? 4 : 0)
                            .frame(width: 56, height: 56)
                    )
                    .onTapGesture {
                        viewModel.apply(.selectIcon(icon))
                    }
                }
                
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    IconSelectPartView(viewModel: AddFolderViewModel(folder: nil))
}
