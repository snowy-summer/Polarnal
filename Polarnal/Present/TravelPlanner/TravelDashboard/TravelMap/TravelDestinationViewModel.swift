//
//  TravelDestinationViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 1/4/25.
//

import Foundation
import Combine
import SwiftData

final class TravelDestinationViewModel: ViewModelProtocol {
    
    enum Intent {
        case deleteDestinationFolder(TravelDestinationFolderDB)
        case editEDestinationFolder(TravelDestinationFolderDB)
        case insertDB(ModelContext)
    }
    
    private let dbManager = DBManager()
    @Published var isShowEditEventCategoryView: EventCategoryDB?
    var cancellables: Set<AnyCancellable> = []
    
    func apply(_ intent: Intent) {
        switch intent {
        case .deleteDestinationFolder(let folder):
            dbManager.deleteItem(folder)
            
        case .editEDestinationFolder(let folder):
//            isShowEditEventCategoryView = folder
            return
            
        case .insertDB(let modelContext):
            dbManager.modelContext = modelContext
        }
    }
    
}
