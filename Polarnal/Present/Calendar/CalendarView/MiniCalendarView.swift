//
//  MiniCalendarView.swift
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

struct MiniCalendarView: View {
    
    @StateObject var viewModel: CalendarViewModel = CalendarViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    viewModel.apply(.previousMonth)
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(Color.normalText)
                }
                .padding()
                
                Text("\(viewModel.calendarYear)년 \(viewModel.calendarMonth)월")
                    .font(.title2)
                    .bold()
                
                Button {
                    viewModel.apply(.nextMonth)
                } label: {
                    Image(systemName: "chevron.forward")
                        .foregroundStyle(Color.normalText)
                }
                .padding()
            }
            
            MiniCalendarContentView(calendarViewModel: viewModel)
        }
    }
    
}

struct MiniCalendarContentView: View {
    
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        HStack {
            ForEach(WeekDay.allCases, id: \.self) { day in
                Text(day.text)
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(day.color)
            }
        }
        
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(Array(calendarViewModel.calendarDateList.enumerated()), id: \.element.id) { index, value in
                if value.day != -1 {
                    let columnIndex = index % columns.count
                    
                    CalendarDateMiniCell(dateValue: value,
                                         isSunday: columnIndex == 0,
                                         isSaturday: columnIndex == 6)
                    
                } else {
                    Text("\(value.day)")
                        .font(.callout)
                        .bold()
                        .foregroundStyle(.clear)
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
        let isSunday: Bool
        let isSaturday: Bool
        var color: Color {
            if isSunday {
                return Color.red
            } else if isSaturday {
                return Color.blue
            } else {
                return Color.normalText
            }
        }
        
        var body: some View {
            ZStack {
                Circle()
                    .fill(isToday ? Color(uiColor: .green.withAlphaComponent(0.5)) : Color.clear)
                    .frame(width: 28, height: 28)
                
                Text("\(dateValue.day)")
                    .foregroundStyle(color)
                    .font(.callout)
                    .bold()
            }
        }
    }
    
}

#Preview {
    PlannerView(sideTabBarViewModel: SideTabBarViewModel())
}
