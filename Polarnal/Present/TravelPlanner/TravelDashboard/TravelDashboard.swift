//
//  TravelDashboard.swift
//  Polarnal
//
//  Created by 최승범 on 12/16/24.
//

import SwiftUI

struct TravelDashboard: View {
    
    @ObservedObject var sideTabBarViewModel: SideTabBarViewModel
    
    var body: some View {
        NavigationSplitView {
            VStack {
                HStack {
                    SideTabBarView(viewModel: sideTabBarViewModel)
                        .frame(width: 80)
                    
                    List {
                        Text("일본 - 도쿄")
                    }
                }
                
            }
            .toolbar(content: {
                ToolbarItem {
                    Button(action: {
                        
                    }) {
                       Image(systemName: "plus")
                    }
                }
            })
        } detail: {
            VStack {
                HStack {
                    TravelTodoMiniView()
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
        
        
    }
}

#Preview {
    TravelDashboard(sideTabBarViewModel: SideTabBarViewModel())
}

struct TravelTodoMiniView: View {

    var body: some View {
        VStack {
            HStack {
                Text("Todo")
                    .font(.title2)
                    .bold()
                Spacer()
                
                Button(action: {
                    
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
                TodoCell(todo: TodoDB(content: "여권 챙기기", folder: TodoFolderDB(title: "여행")))
                    .frame(height: 32)
                
                TodoCell(todo: TodoDB(content: "여권 챙기기", folder: TodoFolderDB(title: "여행")))
                    .frame(height: 32)
                
                TodoCell(todo: TodoDB(content: "여권 챙기기", folder: TodoFolderDB(title: "여행")))
                    .frame(height: 32)
            }
            .listStyle(.plain)
            
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
