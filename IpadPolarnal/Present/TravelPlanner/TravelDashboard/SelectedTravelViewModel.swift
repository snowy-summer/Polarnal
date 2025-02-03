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
    @Published var selectedTravel: TravelPlanDB?
    
    var cancellables: Set<AnyCancellable> = []
    
    func apply(_ intent: Intent) {
        switch intent {
        case .selectTravel(let travelPlanDB):
            selectedTravel = travelPlanDB
        }
    }
}
