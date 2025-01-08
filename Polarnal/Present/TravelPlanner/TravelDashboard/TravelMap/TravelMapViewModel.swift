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
        case addFolder
        case editFolder
        case cleanManager
        case clearSearchText
    }
    
    private let dbManager = DBManager()
    private let searchManager = MapSearchManager()
    var cancellables: Set<AnyCancellable> = []
    
    @Published var sheetType: TravelMapSheetType?
    @Published var searchText: String = ""
    @Published var destinationFolderList: [TravelDestinationFolderDB] = []
    @Published var placeList: [MKLocalSearchCompletion] = []
    
    init() {
        binding()
    }
    
    func apply(_ intent: Intent) {
        switch intent {
        case .addFolder:
            sheetType = .addFolder
            
        case .editFolder:
            sheetType = .editFolder
            
        case .cleanManager:
            searchManager.clean()
            
        case .clearSearchText:
            searchText = ""
            
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
                print(placeList)
            }
            .store(in: &cancellables)
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
