//
//  PlannerView.swift
//  Polarnal
//
//  Created by 최승범 on 12/8/24.
//

import SwiftUI

struct PlannerView: View {
    @ObservedObject var sideTabBarViewModel: SideTabBarViewModel
    @StateObject private var plannerViewModel: PlannerViewModel = PlannerViewModel()
    
    var body: some View {
        NavigationSplitView {
            VStack {
                HStack {
                    SideTabBarView(viewModel: sideTabBarViewModel)
                        .frame(width: 80)
                    
                    VStack {
                        CalendarEventListView(viewModel: plannerViewModel)
                        
                        Divider()
                        
                        CalendarPlanListView()
                    }
                }
                
                Divider()
                
                MiniCalendarView()
                    .background(Color(uiColor: .systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        } detail: {
            
            switch plannerViewModel.showedViewType {
            case .calendar:
                MainCalendarView()
                    .padding(.horizontal)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                // 일정 추가
                                plannerViewModel.apply(.showAddEventCategoryView)
                            }) {
                                Image(systemName: "plus")
                            }
                        }
                    }
                
            case .dday:
                DDayView()
            }
            
        }
        .sheet(item: $plannerViewModel.sheetType, onDismiss: {
            
            // 뒤로 간 경우
        }) { type in
            NavigationStack {
                switch type {
                case .add:
                    Text("추가")
                    
                case .edit:
                    Text("편집")
                    
                default:
                    EmptyView()
                }
            }
        }
        
    }
    
}

#Preview {
    PlannerView(sideTabBarViewModel: SideTabBarViewModel())
}

struct CalendarEventListView: View {
    
    @ObservedObject var viewModel: PlannerViewModel
    
    enum EventType: CaseIterable {
        case reminder
        case dDay
        case deadline
        case dplus
        
        var text: String {
            switch self {
            case .reminder:
                return "미리알림"
                
            case .dDay:
                return "D - Day"
                
            case .deadline:
                return "마감기한"
                
            case .dplus:
                return "D+"
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
        let type: EventType
        let viewModel: PlannerViewModel
        
        var body: some View {
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 32, height: 32)
                    .foregroundStyle(Color.blue)
                
                
                Text(type.text)
                    .bold()
                    .padding(.leading, 8)
                
                Spacer()
                
                Text("3")
            }
            .onTapGesture {
                viewModel.apply(.showDDayView)
            }
        }
    }
}

struct CalendarPlanListView: View {
    var body: some View {
        List {
            CalendarPlanCell()
                .swipeActions(edge: .trailing,
                              allowsFullSwipe: false) {
                    Button(role: .destructive, action: {
                        // 삭제
                    }, label: {
                        Label("삭제", systemImage: "trash")
                    })
                    
                    Button(action: {
                        // 편집
                    }, label: {
                        Label("편집", systemImage: "pencil")
                    })
                }
            CalendarPlanCell()
        }
    }
    
    
    struct CalendarPlanCell: View {
        var body: some View {
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.blue)
                
                
                Text("개인 일정")
                    .bold()
                    .padding(.leading, 8)
                
                Spacer()
                
                Text("6")
            }
            .contextMenu {
                Button(role: .destructive, action: {
                    // 삭제
                }, label: {
                    Label("삭제", systemImage: "trash")
                })
                Button(action: {
                    //편집
                }) {
                    Label("편집", systemImage: "pencil")
                }
            }
        }
    }
}
