//
//  RoutineViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 2/19/25.
//

import Foundation
import Combine
import SwiftData

final class RoutineViewModel: ViewModelProtocol {
    
    enum Intent {
        case deleteRoutine(RoutineDB)
        case ingectDependencies(RoutineUseCaseProtocol)
        case showEditView(RoutineDB)
    }
    
    private var useCase: RoutineUseCaseProtocol?
    
    var cancellables: Set<AnyCancellable> = []
    @Published var routineList: [RoutineDB] = []
    @Published var selectedRoutine: RoutineDB?
    
    func apply(_ intent: Intent) {
        switch intent {
        case .deleteRoutine(let routine):
            useCase?.deleteRoutine(routine)
            
        case .ingectDependencies(let useCase):
            self.useCase = useCase
            let list = useCase.fetchRoutineList()
            routineList = list.map { useCase.sortRoutine($0) }
                
        case .showEditView(let routine):
            selectedRoutine = routine
        }
    }
}
