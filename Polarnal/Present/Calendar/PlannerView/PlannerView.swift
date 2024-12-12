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
                
            case .todo:
                TodoView()
                
            case .dday:
                DDayView()
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
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

#Preview {
    PlannerView(sideTabBarViewModel: SideTabBarViewModel())
}
