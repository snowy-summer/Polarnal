//
//  RoutineRepositoryProtocol.swift
//  Polarnal
//
//  Created by 최승범 on 2/27/25.
//

import Foundation

protocol RoutineRepositoryProtocol {
    func addRoutine(_ routine: RoutineDB)
    func deleteRoutine(_ routine: RoutineDB)
    func fetchRoutineList() -> [RoutineDB]
    func fetchRoutine(_ id: UUID) -> RoutineDB?
}
