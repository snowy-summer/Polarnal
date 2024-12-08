//
//  CalendarView.swift
//  Polarnal
//
//  Created by 최승범 on 12/8/24.
//

import SwiftUI
import Combine

struct CalendarView: View {
    
    @StateObject var viewModel: CalendarViewModel = CalendarViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    viewModel.apply(.previousMonth)
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(.black)
                }
                .padding()
                
                Text("\(viewModel.calendarYear)년 \(viewModel.calendarMonth)월")
                    .font(.title2)
                    .bold()
                
                Button {
                    viewModel.apply(.nextMonth)
                } label: {
                    Image(systemName: "chevron.forward")
                        .foregroundStyle(.black)
                }
                .padding()
            }
            
            WeekdayHeaderView()
            DatesGridView(calendarViewModel: viewModel)
        }
    }
    
}

struct WeekdayHeaderView: View {
    
    private let weekday: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    
    var body: some View {
        HStack {
            ForEach(weekday, id: \.self) { day in
                Text(day)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(day == "일" ? Color.red : Color.black)
            }
        }
        .padding()
    }
}

struct DatesGridView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        // 달력 그리드
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(calendarViewModel.calendarDateList) { value in
                if value.day != -1 {
                    
                    Text("\(value.day)")
                    //                    DateButton(value: value,
                    //                               calendarViewModel: calendarViewModel,
                    //                               selectDate: $calendarViewModel.selectDate)
                    //                        .onTapGesture {
                    //                            calendarViewModel.checkingDate = value.date
                    //                            calendarViewModel.popupDate = true
                    //                            calendarViewModel.checkingDateFuture()
                    //                        }
                } else {
                    // 날짜 공백때문에 -1이 있을경우 숨긴다
                    Text("\(value.day)").hidden()
                }
            }
        }
    }
}

#Preview {
    CalendarView()
}

final class CalendarViewModel: ViewModelProtocol {
    
    enum Intent {
        case nextMonth
        case previousMonth
    }
    
    var cancellables: Set<AnyCancellable> = []
    
    @Published private(set) var calendarYear: Int = 0
    @Published private(set) var calendarMonth: Int = 0
    @Published private var currentDate: Date = Date()
    var calendarDateList = [DateValue]()
    private let dateFormatter = DateFormatter()
    
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

extension CalendarViewModel {
    
    // currentDate 날짜 기준
    private func getYearAndMonthString(currentDate: Date) {
        
        dateFormatter.dateFormat = "YYYY MM"
        dateFormatter.locale = Locale(identifier: "ko_kr")
        
        let date = dateFormatter.string(from: currentDate)
        let yearAndMonth = date.components(separatedBy: " ")
        
        calendarYear = Int(yearAndMonth[0]) ?? 0
        calendarMonth = Int(yearAndMonth[1]) ?? 0
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
        
        return days
    }
    
}

extension Date {
    
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        // 현재 월의 첫 날(startDate) 구하기 -> 일자를 지정하지 않고 year와 month만 구하기 때문에 그 해, 그 달의 첫날을 가지고 옴
        guard let startDate = calendar.date(from: calendar.dateComponents([.year, .month],
                                                                          from: self)) else {
            return []
        }
        print(startDate)
        
        // 해당 월의 일자 범위(날짜 수 가져오는거)
        guard let range = calendar.range(of: .day,
                                         in: .month,
                                         for: startDate) else { return [] }
        
        // range의 각각의 날짜(day)를 Date로 맵핑해서 배열로!!
        return range.compactMap { day -> Date in
            // to: (현재 날짜, 일자)에 day를 더해서 새로운 날짜를 만듦
            calendar.date(byAdding: .day,
                          value: day - 1,
                          to: startDate) ?? Date()
        }
    }
}

struct DateValue: Identifiable {
    var id: UUID = UUID()
    var day: Int
    var date: Date
}
