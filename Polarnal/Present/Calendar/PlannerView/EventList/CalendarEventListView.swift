//
//  CalendarEventListView.swift
//  Polarnal
//
//  Created by 최승범 on 12/11/24.
//

import SwiftUI
import SwiftData

struct CalendarEventListView: View {
    
    @ObservedObject var viewModel: PlannerViewModel
    
    enum EventType: String, CaseIterable {
        case calendar
        case reminder
        case dDay
        
        var text: String {
            switch self {
            case .calendar:
                return "달력"
                
            case .reminder:
                return "ToDo 할일"
                
            case .dDay:
                return "D - Day"
            }
        }
        
        var icon: String {
            switch self {
            case .calendar:
                return "calendar"
                
            case .reminder:
                return "checklist"
                
            case .dDay:
                return "clock.badge.checkmark"
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(EventType.allCases, id: \.self) { type in
                CalendarEventListCell(type: type,
                                      viewModel: viewModel)
            }
        }
    }
    
    struct CalendarEventListCell: View {
        
        @Query var ddayList: [DDayDB]
        let type: EventType
        let viewModel: PlannerViewModel
        
        var body: some View {
            HStack {
                Image(systemName: type.icon)
                
                Text(type.text)
                    .bold()
                    .padding(.leading, 8)
                
                Spacer()
                
                switch type {
                case .calendar:
                    EmptyView()
                    
                case .reminder:
                    Text("0")
                    
                case .dDay:
                    Text("\(ddayList.count)")
                }
            }
            .onTapGesture {
                viewModel.apply(.showDDayView)
            }
        }
    }
}
