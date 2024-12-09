//
//  MainCalendarViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/9/24.
//

import Foundation
import Combine

final class MainCalendarViewModel: ViewModelProtocol {
    
    enum Intent {
        case nextMonth
        case previousMonth
    }
    
    var cancellables: Set<AnyCancellable> = []
    
    @Published private(set) var calendarYear: String = ""
    @Published private(set) var calendarMonth: Int = 0
    @Published private var currentDate: Date = Date()
    var calendarDateList = [DateValue]()
    
    init() {
        binding()
    }
    
    func apply(_ intent: Intent) {
        switch intent {
        case .nextMonth:
            nextMonth()
            
        case .previousMonth:
            previousMonth()
        }
        
    }
    
    private func binding() {
        $currentDate.sink { [weak self] date in
            guard let self else { return }
            getYearAndMonthString(currentDate: date)
        }
        .store(in: &cancellables)
    }
}

extension MainCalendarViewModel {
    
    private func getYearAndMonthString(currentDate: Date) {
        let yearMonthDay = DateManager.shared.getYearAndMonthString(currentDate: currentDate)
        
        calendarYear = yearMonthDay[0]
        calendarMonth = Int(yearMonthDay[1]) ?? 0
        calendarDateList = extractDate(currentDate: currentDate)
    }
    
    private func nextMonth() {
        updateDate(byAddingMonths: 1)
    }
    
    private func previousMonth() {
        updateDate(byAddingMonths: -1)
    }
    
    private func updateDate(byAddingMonths months: Int) {
        if let newDate = Calendar.current.date(byAdding: .month,
                                               value: months,
                                               to: currentDate) {
            LogManager.log("날짜 변경됨 \(newDate)")
            currentDate = newDate
        }
    }
    
    func extractDate(currentDate: Date) -> [DateValue] {
        let calendar = Calendar.current
        
        // currentMonth가 리턴한 month의 모든 날짜 구하기
        var days = currentDate.getAllDates().compactMap { date -> DateValue in
            // 여기서 date = 2023-12-31 15:00:00 +0000
            let day = calendar.component(.day, from: date)
            
            // 여기서 DateValue = DateValue(id: "6D2CCF74-1217-4370-B3AC-1C2E2D9566C9", day: 1, date: 2023-12-31 15:00:00 +0000)
            return DateValue(day: day, date: date)
        }
        
        // days로 구한 month의 가장 첫날이 시작되는 요일구하기
        // Int값으로 나옴. 일요일 1 ~ 토요일 7
        let firstWeekday = calendar.component(.weekday,
                                              from: days.first?.date ?? Date())
        
        // month의 가장 첫날이 시작되는 요일 이전을 채워주는 과정
        // 만약 1월 1일이 수요일에 시작된다면 일~화요일까지 공백이니까 이 자리를 채워주어야 수요일부터 시작되는 캘린더 모양이 생성됨
        // 그래서 만약 수요일(4)이 시작이라고 하면 일(1)~화(3) 까지 for-in문 돌려서 공백 추가
        // 캘린더 뷰에서 월의 첫 주를 올바르게 표시하기 위한 코드
        for _ in 0 ..< firstWeekday - 1 {
            // 여기서 "day: -1"은 실제 날짜가 아니라 공백을 표시한 개념, "date: Date()"도 임시
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        while days.count < 42 {
               days.append(DateValue(day: -1, date: Date()))
        }
        
        return days
    }
    
}


