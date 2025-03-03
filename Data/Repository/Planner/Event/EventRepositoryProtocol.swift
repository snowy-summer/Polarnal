//
//  EventRepositoryProtocol.swift
//  Polarnal
//
//  Created by 최승범 on 2/26/25.
//

import Foundation
import SwiftData

protocol EventRepositoryProtocol {
    func fetchEvents() -> [EventDB]
    func deleteEvent(_ event: EventDB)
}
