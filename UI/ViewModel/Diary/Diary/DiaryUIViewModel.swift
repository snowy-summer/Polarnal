//
//  DiaryUIViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import Foundation
import Combine

final class DiaryUIViewModel: ViewModelProtocol {
    
    enum Intent {
        case showAddFolderView
        case showEditFolderView(Folder)
        case showAddNoteView
        case showPhotoPicker
    }

    @Published var isShowAddNoteView = false
    @Published var isCalendarIsSelected = false
    @Published var sheetType: DiaryViewSheetType?
    
    var cancellables = Set<AnyCancellable>()
    
    func apply(_ intent: Intent) {
        switch intent {
        case .showAddFolderView:
            sheetType = .addFolder(nil)
            
        case .showEditFolderView(let folder):
            sheetType = .editFolder(folder)
            
        case .showAddNoteView:
            isShowAddNoteView = true
            
        case .showPhotoPicker:
            sheetType = .photo
            
        }
    }
    
}


