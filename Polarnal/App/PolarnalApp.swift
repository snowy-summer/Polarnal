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
    
    var body: some Scene {
        WindowGroup {
            if sideTabBarViewModel.isShowMapView {
                TravelMapView(sideTabbarViewModel: sideTabBarViewModel)
            } else {
                switch sideTabBarViewModel.selectedTab {
                case .planner:
                    PlannerView(sideTabBarViewModel: sideTabBarViewModel)
                    
                case .diary:
                    DiaryView(stateViewModel: diaryStateViewModel,
                              uiViewModel: DiaryUIViewModel(),
                              folderViewModel: FolderListViewModel(),
                              noteViewModel: NoteListViewModel(stateViewModel: diaryStateViewModel),
                              sideTabBarViewModel: sideTabBarViewModel)
                case .travelPlanner:
                    TravelDashboard(sideTabBarViewModel: sideTabBarViewModel)
                    
                case .setting:
                    AppSettingView(sideTabBarViewModel: sideTabBarViewModel)
                }
            }
            
        }
        .modelContainer(modelContainer)
    }
}
