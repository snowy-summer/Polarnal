//
//  SideTabBarView.swift
//  Polarnal
//
//  Created by 최승범 on 12/8/24.
//

import SwiftUI

struct SideTabBarView: View {
    @ObservedObject private var viewModel: SideTabBarViewModel
    
    init(viewModel: SideTabBarViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .center) {
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
                    .fill(isSelected ? Color.black : Color.clear)
                    .frame(width: 6, height: 40)
                    .padding(.leading)
                
                ZStack {
                    RoundedRectangle(cornerRadius: isSelected ? 12 : 25)
                        .fill(Color.listBackground)
                        .animation(.linear(duration: 0.3),
                                   value: isSelected)
                        .frame(width: 50,
                               height: 50)
                    
                    Image(systemName: type.iconText)
                        .resizable()
                        .frame(width: 28,
                               height: 28)
                }
            }
        }
    }
    
}

enum TabType: CaseIterable {
    case planner
    case diary
    case travelPlanner
    case setting
    
    var iconText: String {
        switch self {
        case .planner:
            return "calendar"
            
        case .diary:
            return "book.closed.fill"
            
        case .travelPlanner:
            return "airplane.departure"
            
        case .setting:
            return "gearshape.fill"
        }
        
    }
}
