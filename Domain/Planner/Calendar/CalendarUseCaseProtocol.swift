//
//  CalendarUseCaseProtocol.swift
//  Polarnal
//
//  Created by 최승범 on 2/26/25.
//

import Foundation

protocol CalendarUseCaseProtocol {
    func extractDate(currentDate: Date) -> [DateValue]
    func updateDate(currentDate: Date,
                    byAddingMonths months: Int) -> Date
}
