//
//  MiniCalendarView.swift
//  Polarnal
//
//  Created by 최승범 on 12/8/24.
//

import SwiftUI
import Combine

struct MiniCalendarView: View {
    
    @StateObject var viewModel: CalendarViewModel = CalendarViewModel()
    
    private let isMacOS: Bool
    private let calendarYearFont: Font
    
    init(isMacOS: Bool = false) {
        self.isMacOS = isMacOS
        calendarYearFont = isMacOS ? .title3 : .title2
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    viewModel.apply(.previousMonth)
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(Color.normalText)
                }
                .buttonStyle(.plain)
                .padding()
                
                Text("\(viewModel.calendarYear)년 \(viewModel.calendarMonth)월")
                    .font(calendarYearFont)
                    .bold()
                
                Button {
                    viewModel.apply(.nextMonth)
                } label: {
                    Image(systemName: "chevron.forward")
                        .foregroundStyle(Color.normalText)
                }
                .buttonStyle(.plain)
                .padding()
            }
            
            MiniCalendarContentView(calendarViewModel: viewModel,
                                    isMacOS: isMacOS)
        }
    }
    
}

struct MiniCalendarContentView: View {
    
    @ObservedObject var calendarViewModel: CalendarViewModel
    private let isMacOS: Bool
    private let spacing: CGFloat
    private let dayFont: Font
    private let dateFont: Font
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    init(calendarViewModel: CalendarViewModel,
         isMacOS: Bool) {
        _calendarViewModel = ObservedObject(wrappedValue: calendarViewModel)
        self.isMacOS = isMacOS
        self.spacing = isMacOS ? 4 : 8
        self.dayFont = isMacOS ? Font.subheadline : Font.title3
        self.dateFont = isMacOS ? Font.caption : Font.callout
    }
    
    var body: some View {
        HStack {
            ForEach(WeekDay.allCases, id: \.self) { day in
                Text(day.text)
                    .font(dayFont)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(day.color)
            }
        }
        
        LazyVGrid(columns: columns,
                  spacing: spacing) {
            ForEach(Array(calendarViewModel.calendarDateList.enumerated()), id: \.element.id) { index, value in
                if value.day != -1 {
                    let columnIndex = index % columns.count
                    
                    CalendarDateMiniCell(isMacOS: isMacOS,
                                         dateValue: value,
                                         isSunday: columnIndex == 0,
                                         isSaturday: columnIndex == 6)
                    
                } else {
                    Text("\(value.day)")
                        .font(dateFont)
                        .bold()
                        .foregroundStyle(.clear)
                }
            }
        }
    }
    
    struct CalendarDateMiniCell: View {

        private let isMacOS: Bool
        private let circleFrame: CGFloat
        private let dateFont: Font
    
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
        
        init(isMacOS: Bool,
             dateValue: DateValue,
             isSunday: Bool,
             isSaturday: Bool) {
            self.isMacOS = isMacOS
            self.circleFrame = isMacOS ? 20 : 28
            self.dateFont = isMacOS ? .caption : .callout
            self.dateValue = dateValue
            self.isSunday = isSunday
            self.isSaturday = isSaturday
        }
        
        var body: some View {
            ZStack {
                Circle()
                    .fill(isToday ? .calendarSelect : Color.clear)
                    .frame(width: circleFrame,
                           height: circleFrame)
                
                Text("\(dateValue.day)")
                    .foregroundStyle(color)
                    .font(dateFont)
                    .bold()
            }
        }
    }
    
}

#Preview {
    PlannerView(sideTabBarViewModel: SideTabBarViewModel())
}
