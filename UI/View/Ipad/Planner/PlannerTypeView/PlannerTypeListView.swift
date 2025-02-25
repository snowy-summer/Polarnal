//
//  PlannerTypeListView.swift
//  Polarnal
//
//  Created by 최승범 on 12/11/24.
//

import SwiftUI
import SwiftData

struct PlannerTypeListView: View {
    
    @ObservedObject var viewModel: PlannerViewModel
    
    enum EventType: String, CaseIterable {
        case calendar
        case todo
        case dDay
        case routine
        
        var text: String {
            switch self {
            case .calendar:
                return "달력"
                
            case .todo:
                return "Todo 할일"
                
            case .dDay:
                return "D - Day"
                
            case .routine:
                return "Routine"
            }
        }
        
        var icon: String {
            switch self {
            case .calendar:
                return "calendar"
                
            case .todo:
                return "checklist"
                
            case .dDay:
                return "clock.badge.checkmark"
                
            case .routine:
                return "clock.arrow.trianglehead.2.counterclockwise.rotate.90"
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(EventType.allCases, id: \.self) { type in
                PlannerTypeListCell(type: type,
                                      viewModel: viewModel)
                .contentShape(Rectangle())
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.listBackground)
    }
    
    struct PlannerTypeListCell: View {
        
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
                    
                case .dDay:
                    Text("\(ddayList.count)")
                    
                default:
                    EmptyView()
                    
                    
                }
            }
            .onTapGesture {
                switch type {
                case .calendar:
                    viewModel.apply(.showCalendarView)
                    
                case .dDay:
                    viewModel.apply(.showDDayView)
                    
                case.todo:
                    viewModel.apply(.showTodoView)
                    
                case .routine:
                    viewModel.apply(.showRoutineView)
                }
                
            }
        }
    }
}
