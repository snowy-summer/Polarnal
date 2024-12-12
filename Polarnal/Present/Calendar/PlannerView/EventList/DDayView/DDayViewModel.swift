//
//  DDayViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/12/24.
//

import Foundation
import Combine
import SwiftData

final class DDayViewModel: ViewModelProtocol {
    
    enum Intent {
        case deleteDDay(DDayDB)
        case insertModelContext(ModelContext)
        case showEditView(DDayDB)
    }
    
    private let dbManager = DBManager()
    var cancellables: Set<AnyCancellable> = []
    @Published var selectedDDay: DDayDB?
    
    func apply(_ intent: Intent) {
        switch intent {
        case .deleteDDay(let dday):
            dbManager.deleteItem(dday)
            
        case .insertModelContext(let modelContext):
            dbManager.modelContext = modelContext
            
        case .showEditView(let dday):
            selectedDDay = dday
        }
    }
}
