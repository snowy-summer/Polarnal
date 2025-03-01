//
//  PlannerView.swift
//  Polarnal
//
//  Created by 최승범 on 12/8/24.
//
#if os(iOS)
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
                        PlannerTypeListView(viewModel: plannerViewModel)
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
                                    .fill(Color.listBackground)
                                    .frame(height: 44)
                                
                                Label("New Folder", systemImage: "plus.circle")
                                    .font(.headline)
                                    .bold()
                                    .foregroundStyle(Color.normalText)
                                
                            }
                            .padding(.horizontal, 8)
                        }
                    }
                }
                
                Divider()
                
                MiniCalendarView()
                    .background(Color.listBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        } detail: {
            
            switch plannerViewModel.showedViewType {
            case .calendar:
                let viewModel = CalendarViewModel(useCase: CalendarDateUseCase())
                MainCalendarView(viewModel: viewModel)
                    .padding(.horizontal)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                plannerViewModel.apply(.showAddEventView)
                            }) {
                                Image(systemName: "plus")
                                    .tint(Color.normalText)
                            }
                        }
                    }
                    .sheet(item: $plannerViewModel.eventSheetType,
                           onDismiss: {
                        viewModel.apply(.viewUpdate)
                    }) { type in
                        NavigationStack {
                            switch type {
                            case .add:
                                AddEventView(viewModel: AddEventViewModel(eventData: nil))
                            default:
                                EmptyView()
                            }
                        }
                    }
                
            case .todo:
                TodoView()
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                plannerViewModel.apply(.showAddTodoFolder)
                            }) {
                                Image(systemName: "plus")
                                    .tint(Color.normalText)
                            }
                        }
                    }
                    .sheet(item: $plannerViewModel.todoSheetType,
                           onDismiss: {
                        
                    }) { type in
                        NavigationStack {
                            switch type {
                            case .add:
                                AddTodoFolderView(viewModel: AddTodoFolderViewModel(todoFolder: nil))
                                
                            default:
                                EmptyView()
                            }
                        }
                    }
                
            case .dday:
                DDayView()
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                plannerViewModel.apply(.showAddDDay)
                            }) {
                                Image(systemName: "plus")
                                    .tint(Color.normalText)
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
                                AddDDayView(viewModel: AddDDayViewModel(dday: nil))
                            default:
                                EmptyView()
                            }
                        }
                    }
                
            case .routine:
                RoutineView()
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                plannerViewModel.apply(.showAddRoutine)
                            }) {
                                Image(systemName: "plus")
                                    .tint(Color.normalText)
                            }
                        }
                    }
                    .sheet(item: $plannerViewModel.routineSheetType,
                           onDismiss: {
                        
                        // 뒤로 간 경우
                    }) { type in
                        NavigationStack {
                            switch type {
                            case .add:
                                AddRoutineView(viewModel: AddRoutineViewModel(routine: nil,
                                                                              notificationUseCase: RoutineNotificationUseCase()))
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
#endif
