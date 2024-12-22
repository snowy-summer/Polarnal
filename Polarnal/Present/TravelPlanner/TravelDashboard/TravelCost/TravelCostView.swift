//
//  TravelCostView.swift
//  Polarnal
//
//  Created by 최승범 on 12/17/24.
//

import SwiftUI
import SwiftData
import Charts

struct TravelCostView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var selectedTravelViewModel: SelectedTravelViewModel
    @StateObject private var viewModel: TravelCostViewModel = TravelCostViewModel()
    
    var body: some View {
        
        VStack {
            HStack {
                TravelCostOverView(viewModel: viewModel)
                    .background(Color(uiColor: .systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding()
                
                
                TravelCostListView(viewModel: viewModel)
                    .background(Color(uiColor: .systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding()
            }
            
        }
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext,
                                                selectedTravelViewModel.selectedTravelId))
        }
        .toolbar {
            ToolbarItem {
                Button {
                    viewModel.apply(.showAddTravelCostView)
                } label: {
                    Image(systemName: "plus")
                }
                
            }
        }
        .sheet(item: $viewModel.sheetType, onDismiss: {
            viewModel.apply(.fetchList)
        }) { type in
            NavigationStack {
                AddTravelCostView(cost: nil)
            }
        }
        
    }
}

struct TravelCostOverView: View {
    
    @ObservedObject var viewModel: TravelCostViewModel
    
    var body: some View {
        VStack {
            
            Chart(viewModel.chartDataList,
                  id: \.category) { element in
                SectorMark(
                    angle: .value("Usage", element.totalCost),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .cornerRadius(12.0)
                .foregroundStyle(element.category.color)
            }
                  .chartBackground { _ in
                      Text("\(String(format: "%.2f", viewModel.totalCost)) ₩")
                          .font(.title)
                          .bold()
                  }
            
            List {
                ForEach(TravelCostType.allCases, id: \.self) { type in
                    costTypeCell(type: type,
                                 percent: 24.8)
                }
            }
        }
        
    }
    
    
    private func costTypeCell(type: TravelCostType,
                              percent: Double) -> some View {
        HStack {
            Circle()
                .fill(type.color)
                .frame(width: 16, height: 16)
            
            Text(type.title)
                .padding(.leading)
            
            Text(String(format: "%.1f", percent) + "%")
            Spacer()
            Image(systemName: type.icon)
                .resizable()
                .frame(width: 16, height: 16)
        }
    }
}

struct TravelCostListView: View {
    
    @ObservedObject var viewModel: TravelCostViewModel
    private let dateManager = DateManager.shared
    
    var body: some View {
        List {
            ForEach(viewModel.costList, id: \.id) { cost in
                costCell(cost: cost)
                    .swipeActions(edge: .trailing,
                                  allowsFullSwipe: false) {
                        Button(role: .destructive, action: {
                            viewModel.apply(.deleteTravelCost(cost))
                        }, label: {
                            Label("삭제", systemImage: "trash")
                        })
                        
                        Button(action: {
                            //                        viewModel.apply(.editEventCategory(category))
                        }, label: {
                            Label("편집", systemImage: "pencil")
                        })
                    }
            }
        }
    }
    
    private func costCell(cost: TravelCostDB) -> some View {
        HStack {
            Image(systemName: TravelCostType(rawValue: cost.costType)?.icon ?? TravelCostType.other.icon)
                .resizable()
                .frame(width: 44, height: 44)
                .padding()
            
            Text(cost.content)
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(String(format: "%.2f", cost.spentCost)) \(cost.spentCostType)")
                    .font(.title3)
                    .bold()
                Text(dateManager.getDateString(date: cost.date))
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .padding(.top, 4)
            }
            .padding(8)
        }
    }
}

#Preview {
    TravelCostView()
}

// 날짜
// 사진
// 내용
// 금액
// 분야
