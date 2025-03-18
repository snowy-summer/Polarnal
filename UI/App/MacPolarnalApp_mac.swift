//
//  MacPolarnalApp.swift
//  MacPolarnal
//
//  Created by 최승범 on 2/3/25.
//

#if os(macOS)
import SwiftUI
import SwiftData

@main
struct MacPolarnalApp: App {
    private let modelContainer = DBManager.makeModelContainer()
    @StateObject private var sideTabBarViewModel: SideTabBarViewModel = SideTabBarViewModel()
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("userLanguage") private var locale = "ko"
    
    var body: some Scene {
        WindowGroup {
            switch sideTabBarViewModel.selectedTab {
            case .planner:
                PlannerView(sideTabBarViewModel: sideTabBarViewModel)
                    .preferredColorScheme(isDarkMode ? .dark : .light)
                    .environment(\.locale, .init(identifier: locale))
            case .diary:
                DiaryView(sideTabBarViewModel: sideTabBarViewModel)
                    .preferredColorScheme(isDarkMode ? .dark : .light)
                    .environment(\.locale, .init(identifier: locale))
//                
//            case .travelPlanner:
//                //                                TravelDashboard(sideTabBarViewModel: sideTabBarViewModel)
//                //                                    .preferredColorScheme(isDarkMode ? .dark : .light)
//                //                                    .environment(\.locale, .init(identifier: locale))
//                EmptyView()
            case .setting:
                AppSettingView(sideTabBarViewModel: sideTabBarViewModel)
                    .preferredColorScheme(isDarkMode ? .dark : .light)
                    .environment(\.locale, .init(identifier: locale))
                
            }
        }
        .modelContainer(modelContainer)
        
    }
}
#endif
