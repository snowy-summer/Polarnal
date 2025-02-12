//
//  AppSettingView.swift
//  MacPolarnal
//
//  Created by 최승범 on 2/6/25.
//

#if os(macOS)
import SwiftUI

struct AppSettingView: View {
    
    @ObservedObject var sideTabBarViewModel: SideTabBarViewModel
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("userLanguage") private var userLanguage: String = "ko"
    
    private let darkModeTitle: LocalizedStringKey = "Dark Mode"
    private let laguageTitle: LocalizedStringKey = "Lagauges"
    
    var body: some View {
        
        HStack {
            SideTabBarView(viewModel: sideTabBarViewModel)
                .frame(maxHeight: .infinity)
                .frame(width: 72)
            
            List {
                HStack {
                    Text(darkModeTitle)
                        .font(.title3)
                        .bold()
                        .frame(height: 44)
                    Spacer()
                    Toggle("", isOn: $isDarkMode)
                        .labelsHidden()
                }
                
                Picker(laguageTitle, selection: $userLanguage) {
                    ForEach(ContryCode.allCases, id: \.self) { code in
                        Text(code.title).tag(code.rawValue)
                    }
                }
                .font(.title3)
                .bold()
                
            }
            
        }
        
        
    }
}

#endif
