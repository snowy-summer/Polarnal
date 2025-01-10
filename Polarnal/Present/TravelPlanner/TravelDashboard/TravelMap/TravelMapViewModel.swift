//
//  TravelMapViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 1/6/25.
//

import Foundation
import Combine
import SwiftData
import MapKit

final class TravelMapViewModel: ViewModelProtocol {
    
    enum Intent {
        case insertModelContext(ModelContext)
        case showAddFolder
        case showEditFolder
        case cleanManager
        case clearSearchText
        case reloadFolderList
    }
    
    private let dbManager = DBManager()
    private let searchManager = MapSearchManager()
    var cancellables: Set<AnyCancellable> = []
    
    @Published var sheetType: TravelMapSheetType?
    @Published var searchText: String = ""
    @Published var destinationFolderList: [TravelDestinationFolderDB] = []
    @Published var placeList: [MKLocalSearchCompletion] = []
    
    let travelID: UUID
    
    init(travelID: UUID) {
        self.travelID = travelID
        binding()
        updateDestinationFolderList()
    }
    
    func apply(_ intent: Intent) {
        switch intent {
        case .insertModelContext(let model):
            dbManager.modelContext = model
            
        case .showAddFolder:
            sheetType = .addFolder
            
        case .showEditFolder:
            sheetType = .editFolder
            
        case .cleanManager:
            searchManager.clean()
            
        case .clearSearchText:
            searchText = ""
            
        case .reloadFolderList:
            updateDestinationFolderList()
            
        }
    }
    
}

//MARK: - Search
extension TravelMapViewModel {
    
    private func binding() {
        $searchText
        //            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] text in
                guard let self else { return }
                if text.isEmpty {
                    searchManager.upadteCompleterResults(results: nil)
                }
                
                searchManager.updateCompleter(query: text)
                
                //                searchManager.search(for: text)
                //                placeList = searchManager.placeList()
                placeList = searchManager.completerResults ?? []
            }
            .store(in: &cancellables)
    }
    
    private func updateDestinationFolderList() {
        destinationFolderList = dbManager.fetchItems(ofType: TravelDestinationFolderDB.self)
            .filter { folder in
                folder.travelPlanID == travelID
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
