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
    @StateObject var travelIdViewModel: SelectedTravelViewModel = SelectedTravelViewModel()
    
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
                                    travelIdViewModel.apply(.selectTravel(travel))
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
            NavigationStack {
                if let selectedTravel = viewModel.selectedTravel {
                    VStack {
                        HStack {
                            TravelTodoMiniView(travel: selectedTravel)
                                .background(Color(uiColor: .systemGray5))
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                .padding(.trailing)
                            
                            VStack {
                                HStack {
                                    GeometryReader { geometry in
                                        NavigationLink(destination: TravelCostView()) {
                                            TravelTicketMiniView()
                                                .frame(width: geometry.size.width, height: geometry.size.height)
                                                .background(Color(uiColor: .systemGray5))
                                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                        }
                                    }
                                    
                                    GeometryReader { geometry in
                                        NavigationLink(destination: TravelCostView()) {
                                            TravelCostMiniView()
                                                .frame(width: geometry.size.width, height: geometry.size.height)
                                                .background(Color(uiColor: .systemGray5))
                                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                        }
                                    }
                                }
                                
                                HStack {
                                    GeometryReader { geometry in
                                        TravelMapMiniView()
                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                            .clipShape(RoundedRectangle(cornerRadius: 24))
                                    }
                                    
                                    GeometryReader { geometry in
                                        TravelDiaryMiniView()
                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                            .background(Color(uiColor: .systemGray5))
                                            .clipShape(RoundedRectangle(cornerRadius: 24))
                                    }
                                }
                            }
                        }
                        .padding(.bottom)
                        .padding(.horizontal)
                        
                        RoundedRectangle(cornerRadius: 24)
                            .padding(.horizontal)
                    }
                    
                } else {
                    Text("여행을 선택하세요")
                }
            }
            
        }
        .environmentObject(travelIdViewModel)
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext))
            if !travelList.isEmpty && viewModel.selectedTravel == nil {
                viewModel.apply(.selectTravel(travelList[0]))
                travelIdViewModel.apply(.selectTravel(travelList[0]))
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

struct TravelCostMiniView: View {
    var body: some View {
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
