//
//  PlannerView.swift
//  MacPolarnal
//
//  Created by 최승범 on 2/6/25.
//

import SwiftUI
import SwiftData

struct PlannerView: View {
    @Environment(\.modelContext) var modelContext
    @ObservedObject var sideTabBarViewModel: SideTabBarViewModel
    @StateObject private var plannerViewModel: PlannerViewModel = PlannerViewModel()
    
    private let newFolderTitle: LocalizedStringKey = "New Folder"
    
    var body: some View {
        HStack {
            SideTabBarView(viewModel: sideTabBarViewModel)
                .frame(maxHeight: .infinity)
                .frame(width: 72)
            
            NavigationView {
                VStack {
                    PlannerTypeListView(viewModel: plannerViewModel)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal, 8)
                    
                    Divider()
                    
                    CalendarEventCategoryListView()
                        .clipShape(RoundedRectangle(cornerRadius: 8))
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
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.listBackground)
                                .frame(height: 24)
                            
                            Label(newFolderTitle, systemImage: "plus.circle")
                                .font(.title3)
                                .foregroundStyle(Color.normalText)
                            
                        }
                        .padding(.horizontal, 8)
                    }
                    .buttonStyle(.plain)
                    
                    Divider()
                    
                    MiniCalendarView(isMacOS: true)
                        .background(Color.listBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding([.horizontal, .bottom], 8)
                }
                .frame(width: 220)
                
                switch plannerViewModel.showedViewType {
                case .calendar:
                    let viewModel = MainCalendarViewModel()
                    MainCalendarView(viewModel: viewModel)
                        .padding(.horizontal)
                        .toolbar {
                            ToolbarItem {
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
                            ToolbarItem {
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
                            ToolbarItem {
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
                    
                    
                }
            }
        }
    }
    
}

