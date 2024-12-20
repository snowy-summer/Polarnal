//
//  TravelCostView.swift
//  Polarnal
//
//  Created by 최승범 on 12/17/24.
//

import SwiftUI
import SwiftData

struct TravelCostView: View {
    @Environment(\.modelContext) var modelContext
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
        .toolbar {
            ToolbarItem {
                Button {
                    viewModel.apply(.showAddTravelCostView)
                } label: {
                    Image(systemName: "plus")
                }

            }
        }
        .sheet(item: $viewModel.sheetType) { type in
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
            ZStack {
                Circle()
                    .frame(width: 400, height: 400)
                Circle()
                    .fill(Color(uiColor: .systemGray5))
                    .frame(width: 200, height: 200)
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
    
    var body: some View {
        List {
            ForEach(viewModel.costList, id: \.id) { cost in
                costCell(cost: cost)
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
                Text("542,900 ₩")
                    .font(.title3)
                    .bold()
                Text("24.02.12")
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
