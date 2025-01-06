//
//  AppSettingView.swift
//  Polarnal
//
//  Created by 최승범 on 1/4/25.
//

import SwiftUI

struct AppSettingView: View {
    
    @ObservedObject var sideTabBarViewModel: SideTabBarViewModel
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    var body: some View {
        NavigationSplitView {
            HStack {
                SideTabBarView(viewModel: sideTabBarViewModel)
                    .frame(width: 80)
                Spacer()
            }
        } detail: {
            List {
                Toggle(isOn: $isDarkMode) {
                    
                    Text("다크 모드")
                        .frame(height: 44)
                        .font(.title2)
                        .bold()
                }
            }
            
        }
        
        
    }
}

#Preview {
    AppSettingView(sideTabBarViewModel: SideTabBarViewModel())
}
