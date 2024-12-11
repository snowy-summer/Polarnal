//
//  PlannerView.swift
//  Polarnal
//
//  Created by 최승범 on 12/8/24.
//

import SwiftUI
import SwiftData

struct PlannerView: View {
    @Environment(\.modelContext) var modelContext
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
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal, 8)
                        
                        Divider()
                        
                        CalendarEventCategoryListView()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal, 8)
                            .sheet(item: $plannerViewModel.eventCategoryType) { type in
                                let viewModel = AddEventCategoryViewModel(eventCategory: nil)
                                NavigationStack {
                                    AddEventCategoryView(viewModel: viewModel)
                                        .onAppear {
                                            viewModel.apply(.insertModelContext(modelContext))
                                        }
                                }
                                    
                            }
                        
                        Button(action: {
                            plannerViewModel.apply(.showAddEventCategoryView)
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(uiColor: .systemGray5))
                                    .frame(height: 44)
                                HStack {
                                    Image(systemName: "plus.app.fill")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                        .foregroundStyle(.black)
                                    Text("카테고리 추가")
                                        .font(.headline)
                                        .bold()
                                        .foregroundStyle(.black)
                                }
                            }
                            .padding(.horizontal, 8)
                        }
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
                                plannerViewModel.apply(.showAddEventView)
                            }) {
                                Image(systemName: "plus")
                            }
                        }
                    }
                    .sheet(item: $plannerViewModel.eventSheetType,
                           onDismiss: {
                        
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
                
            case .dday:
                DDayView()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                plannerViewModel.apply(.showAddDDay)
                            }) {
                                Image(systemName: "plus")
                            }
                        }
                    }
                    .sheet(item: $plannerViewModel.dDaySheetType,
                           onDismiss: {
                        
                        // 뒤로 간 경우
                    }) { type in
                        NavigationStack {
                            switch type {
                            case .add:
                                Text("D-Day 추가")
                                
                            case .edit:
                                Text("편집")
                                
                            default:
                                EmptyView()
                            }
                        }
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

struct CalendarEventCategoryListView: View {
    
    @Query var eventCategoryList: [EventCategoryDB]
    
    var body: some View {
        List {
            ForEach(eventCategoryList, id: \.id) { category in
                CalendarEventCategoryCell(category: category)
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
            }
        }
    }
    
    
    struct CalendarEventCategoryCell: View {
        
        let category: EventCategoryDB
        
        var body: some View {
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 32, height: 32)
                    .foregroundStyle(category.color.convertToColor())
                
                
                Text(category.title)
                    .bold()
                    .padding(.leading, 8)
                
                Spacer()
                
                Text("\(category.planList.count)")
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
