//
//  TravelMapViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 1/6/25.
//

import Foundation
import Combine
import SwiftData

final class TravelMapViewModel: ViewModelProtocol {
    
    enum Intent {
        case addFolder
        case editFolder
    }
    
    private let dbManager = DBManager()
    var cancellables: Set<AnyCancellable> = []
    
    @Published var sheetType: TravelMapSheetType?
    @Published var searchText: String = ""
    @Published var destinationFolderList: [TravelDestinationFolderDB] = []
    
    func apply(_ intent: Intent) {
        switch intent {
        case .addFolder:
            sheetType = .addFolder
            
        case .editFolder:
            sheetType = .editFolder
        }
    }
    
}

enum TravelMapSheetType: CaseIterable, Identifiable {
    case addFolder
    case editFolder
    
    var id: String {
        switch self {
        case .addFolder:
            return "addFolder"
            
        case .editFolder:
            return "editFolder"
        }
    }
}
