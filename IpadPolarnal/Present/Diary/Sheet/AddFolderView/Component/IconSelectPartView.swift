//
//  IconSelectPartView.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI

struct IconSelectPartView: View {
    
    @ObservedObject var viewModel: AddFolderViewModel
    
#if os(macOS)
    private let circleFrame: CGFloat = 32
    private let spacing: CGFloat = 32
    private let imageFrame: CGFloat = 20
    private let selectCircleFrame: CGFloat = 36
#elseif os(iOS)
    private let circleFrame: CGFloat = 50
    private let spacing: CGFloat = 66
    private let imageFrame: CGFloat = 32
    private let selectCircleFrame: CGFloat = 56
#endif
    
    init(viewModel: AddFolderViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        let columns: [GridItem] = [GridItem(.adaptive(minimum: spacing))]
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(DesignOfFolderIcon.allCases, id: \.self) { icon in
                    
                    ZStack {
                        Circle()
                               .fill(.white)
                               .frame(width: circleFrame, height: circleFrame)

                           Image(systemName: icon.iconName)
                               .resizable()
                               .aspectRatio(contentMode: .fit)
                               .frame(width: imageFrame,
                                      height: imageFrame)

                           if viewModel.folderIcon == icon {
                               Circle()
                                   .stroke(Color.gray, lineWidth: 4)
                                   .frame(width: selectCircleFrame,
                                          height: selectCircleFrame)
                              
                           }
                        
                    }
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
