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

    var body: some Scene {
        WindowGroup {
            DiaryView(stateViewModel: DiaryStateViewModel(),
                      uiViewModel: DiaryUIViewModel(),
                      folderViewModel: FolderListViewModel())
        }
        .modelContainer(modelContainer)
    }
}
