//
//  AppSettingView.swift
//  Polarnal
//
//  Created by 최승범 on 1/4/25.
//

import SwiftUI

struct AppSettingView: View {
    
    @ObservedObject var sideTabBarViewModel: SideTabBarViewModel
    
    var body: some View {
        NavigationSplitView {
                HStack {
                    SideTabBarView(viewModel: sideTabBarViewModel)
                        .frame(width: 80)
                    
                }
        } detail: {
            
            Text("안녕하세여")
            
        }
        
        
    }
}

#Preview {
    AppSettingView(sideTabBarViewModel: SideTabBarViewModel())
}
