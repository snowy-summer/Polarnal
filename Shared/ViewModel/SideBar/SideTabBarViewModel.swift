//
//  SideTabBarViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/10/24.
//

import Foundation
import Combine

final class SideTabBarViewModel: ViewModelProtocol {
    
    enum Intent {
        case selectTab(TabType)
        case showMapView(UUID)
        case dismissShowMapView
    }
    
    @Published var selectedTab: TabType = .planner
    @Published var isShowMapView: Bool = false
    var travelID: UUID?
    var cancellables: Set<AnyCancellable> = []
    
    func apply(_ intent: Intent) {
        switch intent {
        case .selectTab(let tabType):
            selectedTab = tabType
            
        case .showMapView(let travelID):
            isShowMapView = true
            self.travelID = travelID
            
        case .dismissShowMapView:
            isShowMapView = false
        }
    }
    
}
