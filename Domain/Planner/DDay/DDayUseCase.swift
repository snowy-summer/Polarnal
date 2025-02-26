//
//  DDayUseCase.swift
//  Polarnal
//
//  Created by 최승범 on 2/26/25.
//

import Foundation

final class DDayUseCase: DDayUseCaseProtocol {
    
    private let repository: DDayRepositoryProtocol
    
    init(repository: DDayRepositoryProtocol) {
        self.repository = repository
    }
    
    func deleteDDay(_ DDay: DDayDB) {
        repository.deleteDDay(DDay)
    }
}
