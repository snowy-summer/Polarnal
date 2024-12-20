//
//  SelectedTravelViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/20/24.
//

import Foundation
import Combine

final class SelectedTravelViewModel: ViewModelProtocol {
    
    enum Intent {
        case selectTravel(TravelPlanDB)
    }
    @Published var selectedTravelId: UUID?
    
    var cancellables: Set<AnyCancellable> = []
    
    init(selectedTravelId: UUID? = nil) {
        self.selectedTravelId = selectedTravelId
    }
    
    func apply(_ intent: Intent) {
        switch intent {
        case .selectTravel(let travelPlanDB):
            selectedTravelId = travelPlanDB.id
        }
    }
}
