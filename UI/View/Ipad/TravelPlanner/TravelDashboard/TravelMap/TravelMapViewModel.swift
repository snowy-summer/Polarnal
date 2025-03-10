//
//  TravelMapViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 1/6/25.
//
#if os(iOS)
import Foundation
import Combine
import SwiftData
import MapKit
import EnumHelper

final class TravelMapViewModel: ViewModelProtocol {
    
    enum Intent {
        case insertModelContext(ModelContext)
        case showAddFolder
        case showEditFolder
        case cleanManager
        case clearSearchText
        case reloadFolderList
        case selectLocation(MKLocalSearchCompletion)
    }
    
    private let dbManager = DBManager()
    private let searchManager = MapSearchManager()
    var cancellables: Set<AnyCancellable> = []
    
    @Published var sheetType: TravelMapSheetType?
    @Published var searchText: String = ""
    @Published var destinationFolderList: [TravelDestinationFolderDB] = []
    @Published var placeList: [MKLocalSearchCompletion] = []
    @Published var searchRegion = MKCoordinateRegion(MKMapRect.world)
    var selectedPlace: MapPlace? = nil
    
    let travelID: UUID
    
    init(travelID: UUID) {
        self.travelID = travelID
        binding()
    }
    
    func apply(_ intent: Intent) {
        switch intent {
        case .insertModelContext(let model):
            dbManager.modelContext = model
            updateDestinationFolderList()
            
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
            
        case .selectLocation(let location):
            Task {
                let coordinate = await searchManager.search(for: location)
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    searchRegion.center = coordinate
                    searchRegion.span = MKCoordinateSpan(latitudeDelta: 0.05,
                                                         longitudeDelta: 0.05)
                    selectedPlace = MapPlace(title: location.title,
                                             type: location.subtitle,
                                             longitude: coordinate.longitude,
                                             latitude: coordinate.latitude,
                                             travelPlanID: travelID)
                }
            }
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

@IdentifiableEnum
enum TravelMapSheetType: CaseIterable {
    case addFolder
    case editFolder
}
#endif
