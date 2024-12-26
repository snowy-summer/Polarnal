//
//  TravelPlanView.swift
//  Polarnal
//
//  Created by 최승범 on 12/26/24.
//

import SwiftUI
import SwiftData

struct TravelPlanView: View {
    
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var selectedTravelViewModel: SelectedTravelViewModel
    @ObservedObject var viewModel: TravelPlanDetailViewModel
    

    var body: some View {
        GeometryReader { geometryReader in
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.planList,
                            id: \.id) { plan in
                        TravelPlanCell(planDetail: plan)
                            .frame(height: 156)
                            .background {
                                if viewModel.lastCheck(plan: plan) {
                                    DottedLine(isVertical: true)
                                        .stroke(style: StrokeStyle(lineWidth: 4, dash: [10]))
                                        .frame(height: 160)
                                        .offset(x: 12, y: 80)
                                }
                            }
                    }
                }
            }
            .frame(width: geometryReader.size.width / 2)
            .onAppear {
                viewModel.apply(.insertModelContext(modelContext,
                                                    selectedTravelViewModel.selectedTravel))
            }
            
            List {
                Text("aa")
            }
            .frame(width: geometryReader.size.width / 2)
        }
        .padding()
        
    }
}

struct TravelPlanCell: View {
    
    let planDetail: TravelPlanDetailDB
    
    var body: some View {
        HStack(spacing: 40) {
            Circle()
                .fill()
                .frame(width: 24, height: 24)
                .background(.white.shadow(.drop(color: .black.opacity(0.1), radius: 3)), in: .circle)
            
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(uiColor: .systemGray6))
                    .shadow(radius: 4)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.gray)
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: TravelCostType(rawValue: planDetail.type)?.icon ?? TravelCostType.other.icon )
                                .resizable()
                                .frame(width: 32, height: 32)
                            
                        }
                        .padding()
                        Text(planDetail.title)
                            .font(.title3)
                            .bold()
                        Spacer()
                        Text("08:30 AM")
                            .font(.caption)
                            .bold()
                            .foregroundStyle(.gray)
                            .padding()
                        
                    }
                }
            }
            .padding(16)
            
        }
    }
}

#Preview {
    TravelPlanView(viewModel: TravelPlanDetailViewModel())
}
