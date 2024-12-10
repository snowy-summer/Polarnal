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
            switch sideTabBarViewModel.selectedTab {
            case .calendar:
                PlannerView(sideTabBarViewModel: sideTabBarViewModel)
                
            case .diary:
                DiaryView(stateViewModel: diaryStateViewModel,
                          uiViewModel: DiaryUIViewModel(),
                          folderViewModel: FolderListViewModel(),
                          noteViewModel: NoteListViewModel(stateViewModel: diaryStateViewModel),
                          sideTabBarViewModel: sideTabBarViewModel)
            case .travelPlanner:
                Text("선택")
            }
            
        }
        .modelContainer(modelContainer)
    }
}
