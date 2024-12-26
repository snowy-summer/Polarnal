//
//  MainCalendarCellViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/13/24.
//

import SwiftUI
import SwiftData
import Combine

final class MainCalendarCellViewModel: ViewModelProtocol {
    
    private let dbManager = DBManager()
    private let dateManager = DateManager.shared
    var cancellables: Set<AnyCancellable> = []
    
    let dateValue: DateValue
    @Published var eventList: [EventDB] = []
    
    let isSunday: Bool
    let isSaturday: Bool
    let isEmptyView: Bool
    var isToday: Bool {
        if isEmptyView { return false }
        let inputYearMonthDay = DateManager.shared.getYearAndMonthString(currentDate: dateValue.date)
        let currentYearMonthDay = DateManager.shared.getYearAndMonthString(currentDate: Date())
        return inputYearMonthDay == currentYearMonthDay
    }
    var color: Color {
        if isSunday {
            return Color.red
        } else if isSaturday {
            return Color.blue
        } else {
            return Color.black
        }
    }
    
    init(dateValue: DateValue,
         isSunday: Bool,
         isSaturday: Bool,
         isEmptyView: Bool) {
        self.dateValue = dateValue
        self.isSunday = isSunday
        self.isSaturday = isSaturday
        self.isEmptyView = isEmptyView
    }
    
    enum Intent {
        case insertModelContext(ModelContext)
    }
    
    func apply(_ intent: Intent) {
        switch intent {
        case .insertModelContext(let modelContext):
            dbManager.modelContext = modelContext
            getEventList()
        }
    }
}

extension MainCalendarCellViewModel {
    
    private func getEventList() {
        if isEmptyView { return }
        let allEventList = dbManager.fetchItems(ofType: EventDB.self)
        eventList = allEventList.filter {
            dateManager.getDateString(date: dateValue.date) == dateManager.getDateString(date: $0.date)
        }.sorted {
            $0.category.title < $1.category.title
        }
        
    }
}
