//
//  PolarnalApp.swift
//  Polarnal
//
//  Created by 최승범 on 12/3/24.
//

import SwiftUI
import SwiftData

@main
struct PolarnalApp: App {
    private let modelContainer = DBManager.makeModelContainer()
    @StateObject private var sideTabBarViewModel: SideTabBarViewModel = SideTabBarViewModel()
    private let diaryStateViewModel: DiaryStateViewModel = DiaryStateViewModel()
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("userLanguage") private var locale = "ko"

    var body: some Scene {
        WindowGroup {
            if sideTabBarViewModel.isShowMapView {
                if let id = sideTabBarViewModel.travelID {
                    TravelMapView(sideTabbarViewModel: sideTabBarViewModel,
                                  viewModel: TravelMapViewModel(travelID: id))
                    .preferredColorScheme(isDarkMode ? .dark : .light)
                    .environment(\.locale, .init(identifier: locale))
                }
            } else {
                switch sideTabBarViewModel.selectedTab {
                case .planner:
                    PlannerView(sideTabBarViewModel: sideTabBarViewModel)
                        .preferredColorScheme(isDarkMode ? .dark : .light)
                        .environment(\.locale, .init(identifier: locale))
                case .diary:
                    DiaryView(stateViewModel: diaryStateViewModel,
                              uiViewModel: DiaryUIViewModel(),
                              folderViewModel: FolderListViewModel(),
                              noteViewModel: NoteListViewModel(),
                              sideTabBarViewModel: sideTabBarViewModel)
                    .preferredColorScheme(isDarkMode ? .dark : .light)
                    .environment(\.locale, .init(identifier: locale))
                    
                case .travelPlanner:
                    TravelDashboard(sideTabBarViewModel: sideTabBarViewModel)
                        .preferredColorScheme(isDarkMode ? .dark : .light)
                        .environment(\.locale, .init(identifier: locale))
                    
                case .setting:
                    AppSettingView(sideTabBarViewModel: sideTabBarViewModel)
                        .preferredColorScheme(isDarkMode ? .dark : .light)
                        .environment(\.locale, .init(identifier: locale))
                }
            }
            
        }
        .modelContainer(modelContainer)
    }
}
