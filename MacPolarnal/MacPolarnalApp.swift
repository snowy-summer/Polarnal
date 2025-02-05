//
//  MacPolarnalApp.swift
//  MacPolarnal
//
//  Created by 최승범 on 2/3/25.
//

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
            DiaryView(sideTabBarViewModel: sideTabBarViewModel)
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .environment(\.locale, .init(identifier: locale))
//            if sideTabBarViewModel.isShowMapView {
////                if let id = sideTabBarViewModel.travelID {
////                    TravelMapView(sideTabbarViewModel: sideTabBarViewModel,
////                                  viewModel: TravelMapViewModel(travelID: id))
////                    .preferredColorScheme(isDarkMode ? .dark : .light)
////                    .environment(\.locale, .init(identifier: locale))
////                }
//            } else {
//                switch sideTabBarViewModel.selectedTab {
//                case .planner:
////                    PlannerView(sideTabBarViewModel: sideTabBarViewModel)
////                        .preferredColorScheme(isDarkMode ? .dark : .light)
////                        .environment(\.locale, .init(identifier: locale))
//                    EmptyView()
//                case .diary:
//                    DiaryView(stateViewModel: diaryStateViewModel,
//                              uiViewModel: DiaryUIViewModel(),
//                              folderViewModel: FolderListViewModel(),
//                              noteViewModel: NoteListViewModel(stateViewModel: diaryStateViewModel),
//                              sideTabBarViewModel: sideTabBarViewModel)
//                    .preferredColorScheme(isDarkMode ? .dark : .light)
//                    .environment(\.locale, .init(identifier: locale))
//                    
//                case .travelPlanner:
////                    TravelDashboard(sideTabBarViewModel: sideTabBarViewModel)
////                        .preferredColorScheme(isDarkMode ? .dark : .light)
////                        .environment(\.locale, .init(identifier: locale))
//                    EmptyView()
//                case .setting:
////                    AppSettingView(sideTabBarViewModel: sideTabBarViewModel)
////                        .preferredColorScheme(isDarkMode ? .dark : .light)
////                        .environment(\.locale, .init(identifier: locale))
//                    EmptyView()
//                }
//            }
            
        }
        .modelContainer(modelContainer)
    }
}
