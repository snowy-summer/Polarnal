//
//  AppSettingView.swift
//  Polarnal
//
//  Created by 최승범 on 1/4/25.
//

#if os(iOS)
import SwiftUI

struct AppSettingView: View {
    
    @ObservedObject var sideTabBarViewModel: SideTabBarViewModel
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("userLanguage") private var userLanguage: String = "ko"
    
    private let darkModeTitle: LocalizedStringKey = "Dark Mode"
    private let laguageTitle: LocalizedStringKey = "Lagauges"
    
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
                    
                    Text(darkModeTitle)
                        .frame(height: 44)
                        .font(.title2)
                        .bold()
                }
                
                Picker(laguageTitle, selection: $userLanguage) {
                    ForEach(ContryCode.allCases, id: \.self) { code in
                        Text(code.title).tag(code.rawValue)
                    }
                }
                .font(.title2)
                .bold()
                .frame(height: 44)
                
            }
            
        }
        
        
    }
}

#Preview {
    AppSettingView(sideTabBarViewModel: SideTabBarViewModel())
}
#endif
