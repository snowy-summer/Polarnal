//
//  DDayViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/12/24.
//

import Foundation
import Combine

final class DDayViewModel: ViewModelProtocol {
    
    enum Intent {
        case deleteDDay(DDayDB)
        case ingectDependencies(useCase: DDayUseCaseProtocol)
        case showEditView(DDayDB)
    }
    
    private var useCase: DDayUseCaseProtocol?

    var cancellables: Set<AnyCancellable> = []
    @Published var selectedDDay: DDayDB?
    
    func apply(_ intent: Intent) {
        switch intent {
        case .deleteDDay(let dday):
            useCase?.deleteDDay(dday)
            
        case .ingectDependencies(let useCase):
            self.useCase = useCase
            
        case .showEditView(let dday):
            selectedDDay = dday
        }
    }
}
