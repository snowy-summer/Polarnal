//
//  EventCategoryUseCase.swift
//  Polarnal
//
//  Created by 최승범 on 2/27/25.
//

import Foundation

final class EventCategoryUseCase: EventCategoryUseCaseProtocol {
    
    private let eventCategoryRepository: EventCategoryRepositoryProtocol
    
    init(eventCategoryRepository: EventCategoryRepositoryProtocol) {
        self.eventCategoryRepository = eventCategoryRepository
    }
    
    func deleteEventCategory(_ category: EventCategoryDB) {
        eventCategoryRepository.deleteEventCategory(category)
    }
}
