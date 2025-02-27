//
//  CalendarEventCategoryViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/11/24.
//

import Foundation
import Combine
import SwiftData

final class CalendarEventCategoryViewModel: ViewModelProtocol {
    
    enum Intent {
        case deleteEventCategory(EventCategoryDB)
        case editEventCategory(EventCategoryDB)
        case ingectDependencies(useCase: EventCategoryUseCase)
    }
    
    private var useCase: EventCategoryUseCaseProtocol?
    @Published var isShowEditEventCategoryView: EventCategoryDB?
    var cancellables: Set<AnyCancellable> = []
    
    func apply(_ intent: Intent) {
        switch intent {
        case .deleteEventCategory(let category):
            useCase?.deleteEventCategory(category)
            
        case .editEventCategory(let category):
            isShowEditEventCategoryView = category
            
        case .ingectDependencies(let useCase):
            self.useCase = useCase
        }
    }
    
}
