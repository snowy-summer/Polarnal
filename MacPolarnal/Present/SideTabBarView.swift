//
//  SideTabBarView.swift
//  MacPolarnal
//
//  Created by 최승범 on 2/6/25.
//

import SwiftUI

struct SideTabBarView: View {
    @ObservedObject private var viewModel: SideTabBarViewModel
    
    init(viewModel: SideTabBarViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Rectangle()
                .frame(height: 8)
                .opacity(0)
            
            ForEach(TabType.allCases, id: \.self) { type in
                if type != TabType.setting {
                    TabIconCell(type: type,
                                isSelected: viewModel.selectedTab == type)
                    .onTapGesture {
                        viewModel.apply(.selectTab(type))
                    }
                }
            }
            
            
            Spacer()
            
            TabIconCell(type: .setting,
                        isSelected: viewModel.selectedTab == TabType.setting)
            .onTapGesture {
                viewModel.apply(.selectTab(TabType.setting))
            }
        }
        .padding(.trailing)
        .padding(.bottom)
        .background(.ipadTabbar)
    }
    
    struct TabIconCell: View {
        let type: TabType
        var isSelected: Bool
        
        var body: some View {
            
            HStack {
                RoundedRectangle(cornerRadius: 3)
                    .fill(isSelected ? Color.normalText : Color.clear)
                    .frame(width: 6, height: 40)
                    .padding(.leading)
                
                ZStack {
                    RoundedRectangle(cornerRadius: isSelected ? 12 : 22)
                        .fill(Color.listBackground)
                        .animation(.linear(duration: 0.3),
                                   value: isSelected)
                        .frame(width: 44,
                               height: 44)
                    
                    Image(systemName: type.iconText)
                        .resizable()
                        .frame(width: 16,
                               height: 16)
                }
            }
        }
    }
    
}
