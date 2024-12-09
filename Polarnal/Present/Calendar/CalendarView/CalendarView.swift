//
//  CalendarView.swift
//  Polarnal
//
//  Created by 최승범 on 12/8/24.
//

import SwiftUI
import Combine

struct DateValue: Identifiable {
    var id: UUID = UUID()
    var day: Int
    var date: Date
}

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
            
            CalendarContentView(calendarViewModel: viewModel)
        }
    }
    
}

struct CalendarContentView: View {
    
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    private let weekday: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        HStack {
            ForEach(weekday, id: \.self) { day in
                Text(day)
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(day == "일" ? Color.red : Color.black)
            }
        }
        
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(Array(calendarViewModel.calendarDateList.enumerated()), id: \.element.id) { index, value in
                if value.day != -1 {
                    let columnIndex = index % columns.count
                    
                    CalendarDateMiniCell(dateValue: value,
                                         isHoliday: columnIndex == 0)
                    
                } else {
                    Text("\(value.day)").hidden()
                }
            }
        }
    }
    
    struct CalendarDateMiniCell: View {
        
        let dateValue: DateValue
        var isToday: Bool {
            let inputYearMonthDay = DateManager.shared.getYearAndMonthString(currentDate: dateValue.date)
            let currentYearMonthDay = DateManager.shared.getYearAndMonthString(currentDate: Date())
            return inputYearMonthDay == currentYearMonthDay
        }
        let isHoliday: Bool
        
        var body: some View {
            ZStack {
                Circle()
                    .fill(isToday ? Color.blue : Color.clear)
                    .frame(width: 44, height: 44)
                
                Text("\(dateValue.day)")
                    .foregroundStyle(isHoliday ? Color.red : Color.black)
                    .font(.title2)
                    .bold()
            }
        }
    }
    
}

#Preview {
    CalendarView()
}
