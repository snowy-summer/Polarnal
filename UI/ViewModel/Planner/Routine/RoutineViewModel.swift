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
        case fetchList
    }
    
    private var useCase: RoutineUseCaseProtocol?
    private let notificationUseCase: RoutineNotificationUseCaseProtocol
    
    var cancellables: Set<AnyCancellable> = []
    @Published var routineList: [RoutineDB] = []
    @Published var selectedRoutine: RoutineDB?
    
    init(notificationUseCase: RoutineNotificationUseCaseProtocol = RoutineNotificationUseCase()) {
        self.notificationUseCase = notificationUseCase
    }
    
    func apply(_ intent: Intent) {
        switch intent {
        case .deleteRoutine(let routine):
            useCase?.deleteRoutine(routine)
            notificationUseCase.removeRoutineNotification(for: routine)
            fetchList()
            
        case .ingectDependencies(let useCase):
            self.useCase = useCase
            fetchList()
                
        case .showEditView(let routine):
            selectedRoutine = routine
            
        case .fetchList:
            fetchList()
        }
    }
    
    func fetchList() {
        guard let useCase else { return }
        let list = useCase.fetchRoutineList()
        routineList = list.map { useCase.sortRoutine($0) }
    }
}
