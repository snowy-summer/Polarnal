//
//  MainCalendarView.swift
//  Polarnal
//
//  Created by 최승범 on 12/9/24.
//

import SwiftUI
import SwiftData

struct MainCalendarView: View {
    
    @ObservedObject var viewModel: MainCalendarViewModel
    
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
            
            MainCalendarContentView(calendarViewModel: viewModel)
        }
    }
    
}

struct MainCalendarContentView: View {
    
    @ObservedObject var calendarViewModel: MainCalendarViewModel
    
    private let columns = Array(repeating: GridItem(.flexible()),
                                count: 7)
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
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
                            
                            MainCalendarDateCell(dateValue: value,
                                                 isSunday: columnIndex == 0,
                                                 isSaturday: columnIndex == 6,
                                                 isEmptyView: false)
                            .background(Color.contentBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(height: geometry.size.height / 7)
                            
                        } else {
                            MainCalendarDateCell(dateValue: value,
                                                 isSunday: false,
                                                 isSaturday: false,
                                                 isEmptyView: true)
                            .foregroundStyle(.clear)
                            .background(Color.contentBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(height: geometry.size.height / 7)
                        }
                    }
                }
            }
        }
    }
    
    struct MainCalendarDateCell: View {
        @Environment(\.modelContext) var modelContext
        @StateObject var viewModel: MainCalendarCellViewModel
    
        init(dateValue: DateValue,
             isSunday: Bool,
             isSaturday: Bool,
             isEmptyView: Bool = false) {
            self._viewModel = StateObject(wrappedValue: MainCalendarCellViewModel(dateValue: dateValue,
                                                                                  isSunday: isSunday,
                                                                                  isSaturday: isSaturday,
                                                                                  isEmptyView: isEmptyView))
        }
        
        var body: some View {
            VStack {
                HStack {
                    Text("\(viewModel.dateValue.day)")
                        .foregroundStyle(viewModel.isEmptyView ? .clear : viewModel.color)
                        .font(.headline)
                        .bold()
                        .padding(.leading, 8)
                        .padding(.top, 8)
                    
                    Spacer()
                }
                ScrollView {
                    LazyVStack(spacing: 4) {
                        ForEach(viewModel.eventList, id: \.id) { event in
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(hex: event.category?.colorCode ?? "#FFFFFF"))
                                    .frame(height: 20)

                                Text(event.content)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .font(.callout)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 4)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.apply(.insertModelContext(modelContext))
            }
        }
    }
}
