//
//  SideTabBarViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/10/24.
//

import Combine

final class SideTabBarViewModel: ViewModelProtocol {
    
    enum Intent {
        case selectTab(TabType)
        case showMapView
        case dismissShowMapView
    }
    
    @Published var selectedTab: TabType = .planner
    @Published var isShowMapView: Bool = false
    var cancellables: Set<AnyCancellable> = []
    
    func apply(_ intent: Intent) {
        switch intent {
        case .selectTab(let tabType):
            selectedTab = tabType
            
        case .showMapView:
            isShowMapView = true
            
        case .dismissShowMapView:
            isShowMapView = false
        }
    }
    
}
