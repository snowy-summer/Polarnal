//
//  DDayRepositoryProtocol.swift
//  Polarnal
//
//  Created by 최승범 on 2/26/25.
//

import Foundation

protocol DDayRepositoryProtocol {
    func fetchDDay() -> [DDayDB]
    func deleteDDay(_ DDay: DDayDB)
}
