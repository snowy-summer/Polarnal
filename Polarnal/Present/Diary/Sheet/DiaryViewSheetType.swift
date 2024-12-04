//
//  DiaryViewSheetType.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import Foundation

enum DiaryViewSheetType: Identifiable {
    
    case addFolder(Folder?)
    case editFolder(Folder)
    case photo
    
    var id: String {
        switch self {
        case .addFolder:
            return "addFolder"
            
        case .editFolder:
            return "editFolder"
            
        case .photo:
            return "photo"
            
        }
    }
}
