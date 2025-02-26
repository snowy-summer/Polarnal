//
//  CalendarViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/9/24.
//

import SwiftUI
import Combine

final class CalendarViewModel: ViewModelProtocol {
    
    enum Intent {
        case nextMonth
        case previousMonth
        case viewUpdate
    }
    
    private let calendarUseCase: CalendarDateUseCaseProtocol
    
    @Published private(set) var calendarYear: String = ""
    @Published private(set) var calendarMonth: Int = 0
    @Published private var currentDate: Date = Date()
    @Published var trigger = false
    @Published var calendarDateList = [DateValue]()
    
    var cancellables: Set<AnyCancellable> = []
    
    init(useCase: CalendarDateUseCaseProtocol) {
        calendarUseCase = useCase
        getYearAndMonthString(currentDate: currentDate)
    }
    
    func apply(_ intent: Intent) {
        switch intent {
        case .nextMonth:
            currentDate = calendarUseCase.updateDate(currentDate: currentDate,
                                                     byAddingMonths: 1)
            
        case .previousMonth:
            currentDate = calendarUseCase.updateDate(currentDate: currentDate,
                                                     byAddingMonths: -1)
            
        case .viewUpdate:
            trigger.toggle()
            return
        }
        
        getYearAndMonthString(currentDate: currentDate)
        
    }
    
}

extension CalendarViewModel {
    
    private func getYearAndMonthString(currentDate: Date) {
        let yearMonthDay = DateManager.shared.getYearAndMonthString(currentDate: currentDate)
        
        calendarYear = yearMonthDay[0]
        calendarMonth = Int(yearMonthDay[1]) ?? 0
        calendarDateList = calendarUseCase.extractDate(currentDate: currentDate)
    }
    
}


struct DateValue: Identifiable {
    var id: UUID = UUID()
    var day: Int
    var date: Date
}

enum WeekDay: CaseIterable {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var text: String {
        switch self {
        case .sunday:
            return "일"
        case .monday:
            return "월"
        case .tuesday:
            return "화"
        case .wednesday:
            return "수"
        case .thursday:
            return "목"
        case .friday:
            return "금"
        case .saturday:
            return "토"
        }
    }
    
    var color: Color {
        switch self {
        case .sunday:
            return Color.red
            
        case .saturday:
            return Color.blue
            
        default:
            return Color.folderTitle
        }
    }
}
