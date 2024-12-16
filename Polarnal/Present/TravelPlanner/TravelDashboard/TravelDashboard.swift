//
//  TravelDashboard.swift
//  Polarnal
//
//  Created by 최승범 on 12/16/24.
//

import SwiftUI
import SwiftData

struct TravelDashboard: View {
    
    @Environment(\.modelContext) var modelContext
    @ObservedObject var sideTabBarViewModel: SideTabBarViewModel
    @Query var travelList: [TravelPlanDB]
    @StateObject var viewModel: TravelDashboardViewModel = TravelDashboardViewModel()
    
    var body: some View {
        NavigationSplitView {
            VStack {
                HStack {
                    SideTabBarView(viewModel: sideTabBarViewModel)
                        .frame(width: 80)
                    
                    List {
                        ForEach(travelList, id: \.id) { travel in
                            TravelListCell(travel: travel)
                                .onTapGesture {
                                    viewModel.apply(.selectTravel(travel))
                                }
                        }
                    }
                }
                
            }
            .toolbar(content: {
                ToolbarItem {
                    Button(action: {
                        viewModel.apply(.showAddTravelView)
                    }) {
                       Image(systemName: "plus")
                    }
                }
            })
            .sheet(item: $viewModel.sheetType) { type in
                NavigationStack {
                    switch type {
                    case .addTravelPlan:
                        AddTravelPlanView(viewModel: AddTravelPlanViewModel(travelPlanData: nil))
                        
                    case .editTravelPlan:
                        AddTravelPlanView(viewModel: AddTravelPlanViewModel(travelPlanData: viewModel.selectedTravel))
                    }
                }
                
                
            }
        } detail: {
            VStack {
                HStack {
                    TravelTodoMiniView(viewModel: viewModel)
                        .background(Color(uiColor: .systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .padding(.trailing)
                        
                    VStack {
                        HStack {
                            TravelTicketMiniView()
                                .background(Color(uiColor: .systemGray5))
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                            
                            RoundedRectangle(cornerRadius: 24)
                                .overlay {
                                    Circle()
                                        .fill(.blue)
                                        .padding()
                                        .overlay {
                                            Circle()
                                                .fill()
                                                .padding(60)
                                        }
                                }
                        }
                        
                        HStack {
                            TravelMapMiniView()
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                            TravelDiaryMiniView()
                                .background(Color(uiColor: .systemGray5))
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                
                        }
                    }
                }
                .padding(.bottom)
                .padding(.horizontal)
                
                RoundedRectangle(cornerRadius: 24)
                    .padding(.horizontal)
            }
            
        }
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext))
            if !travelList.isEmpty && viewModel.selectedTravel == nil {
                viewModel.apply(.selectTravel(travelList[0]))
            }
        }
        
        
    }
    
    struct TravelListCell: View {
        let travel: TravelPlanDB
        
        var body: some View {
            Text(travel.title)
        }
    }
}

#Preview {
    TravelDashboard(sideTabBarViewModel: SideTabBarViewModel())
}

struct TravelTodoMiniView: View {

    @ObservedObject var viewModel: TravelDashboardViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Todo")
                    .font(.title2)
                    .bold()
                Spacer()
                
                Button(action: {
                    viewModel.apply(.addTodo)
                }, label: {
                    Image(systemName: "plus")
                        .tint(.black)
                        .bold()
                })
            }
            .padding(.top)
            .padding(.horizontal)
            
            Divider()
            
            List {
                ForEach(viewModel.selectedTravel?.todoList ?? [], id: \.id) { todo in
                    TravelTodoCell(todo: todo)
                        .frame(height: 32)
                    // done, 삭제 추가 해야됨
                }
            }
            .listStyle(.plain)
            
        }
    }
    
    struct TravelTodoCell: View {
        
        let todo: TravelTodoDB
        
        var body: some View {
            HStack {
                if todo.isDone {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .foregroundStyle(.red)
                        .frame(width: 24, height: 24)
                } else {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .foregroundStyle(.blue)
                        .frame(width: 24, height: 24)
                }
                
                Text(todo.content)
                    .font(.title3)
                    .bold()
                    .padding(.horizontal)
            }
            .padding()
        }
    }
}

struct TravelTicketMiniView: View {
    var body: some View {
        VStack {
            HStack {
                Text("티켓 & 예약 정보")
                    .font(.title2)
                    .bold()
                Spacer()
                Text("3")
                    .font(.title3)
            }
            .padding(.top)
            .padding(.horizontal)
            
            Divider()
            
            List {
                Text("✈️  비행기 티켓")
                Text("🚃  교통 패스")
                Text("🏨  숙소 예약 정보")
            }
            .listStyle(.plain)
            
            
        }
    }
}

struct TravelMapMiniView: View {
    var body: some View {
        ZStack {
            Image(.mapSkeleton)
                .resizable()
            VStack {
                HStack {
                    Text("여행지 지도")
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal)
                
                Divider()
                
                Spacer()
                
            }
        }
        
    }
}

struct TravelDiaryMiniView: View {
    var body: some View {
            VStack {
                HStack {
                    Text("여행 기록")
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal)
                
                Divider()
                
                Spacer()
                
            }
    }
}
