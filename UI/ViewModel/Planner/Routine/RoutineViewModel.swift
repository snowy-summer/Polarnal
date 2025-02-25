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
        case insertModelContext(ModelContext)
        case showEditView(RoutineDB)
    }
    
    private let dbManager = DBManager()
    var cancellables: Set<AnyCancellable> = []
    @Published var selectedRoutine: RoutineDB?
    
    func apply(_ intent: Intent) {
        switch intent {
        case .deleteRoutine(let routine):
            dbManager.deleteItem(routine)
            
        case .insertModelContext(let modelContext):
            dbManager.modelContext = modelContext
            
        case .showEditView(let routine):
            selectedRoutine = routine
        }
    }
}
