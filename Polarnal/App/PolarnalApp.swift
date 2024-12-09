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
    private let diaryStateViewModel: DiaryStateViewModel = DiaryStateViewModel()

    var body: some Scene {
        WindowGroup {
            DiaryView(stateViewModel: diaryStateViewModel,
                      uiViewModel: DiaryUIViewModel(),
                      folderViewModel: FolderListViewModel(),
                      noteViewModel: NoteListViewModel(stateViewModel: diaryStateViewModel))
            
//            PlannerView()
        }
        .modelContainer(modelContainer)
    }
}
