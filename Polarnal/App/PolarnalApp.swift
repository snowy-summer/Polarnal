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
    
    var body: some Scene {
        WindowGroup {
            if sideTabBarViewModel.isShowMapView {
                if let id = sideTabBarViewModel.travelID {
                    TravelMapView(sideTabbarViewModel: sideTabBarViewModel,
                                  viewModel: TravelMapViewModel(travelID: id))
                    .preferredColorScheme(isDarkMode ? .dark : .light)
                }
            } else {
                switch sideTabBarViewModel.selectedTab {
                case .planner:
                    PlannerView(sideTabBarViewModel: sideTabBarViewModel)
                        .preferredColorScheme(isDarkMode ? .dark : .light)
                case .diary:
                    DiaryView(stateViewModel: diaryStateViewModel,
                              uiViewModel: DiaryUIViewModel(),
                              folderViewModel: FolderListViewModel(),
                              noteViewModel: NoteListViewModel(stateViewModel: diaryStateViewModel),
                              sideTabBarViewModel: sideTabBarViewModel)
                    .preferredColorScheme(isDarkMode ? .dark : .light)
                    
                case .travelPlanner:
                    TravelDashboard(sideTabBarViewModel: sideTabBarViewModel)
                        .preferredColorScheme(isDarkMode ? .dark : .light)
                    
                case .setting:
                    AppSettingView(sideTabBarViewModel: sideTabBarViewModel)
                        .preferredColorScheme(isDarkMode ? .dark : .light)
                }
            }
            
        }
        .modelContainer(modelContainer)
    }
}
