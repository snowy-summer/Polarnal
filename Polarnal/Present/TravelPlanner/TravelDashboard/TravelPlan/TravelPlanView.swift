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
            HStack {
                VStack {
                    HStack {
                        Button {
                            viewModel.apply(.selectPreviousDate)
                        } label: {
                            Image(systemName: "chevron.backward")
                                .foregroundStyle(.black)
                        }
                        .padding()
                        
                        Text("2024.04.12")
                            .font(.title2)
                            .bold()
                        
                        Button {
                            viewModel.apply(.selectNextDate)
                        } label: {
                            Image(systemName: "chevron.forward")
                                .foregroundStyle(.black)
                        }
                        .padding()
                    }
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.planList,
                                    id: \.id) { plan in
                                TravelPlanCell(planDetail: plan)
                                    .frame(height: 156)
                                    .background {
                                        if !viewModel.lastCheck(plan: plan) {
                                            DottedLine(isVertical: true)
                                                .stroke(style: StrokeStyle(lineWidth: 4, dash: [10]))
                                                .frame(height: 160)
                                                .offset(x: 12, y: 80)
                                        }
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
        }
        .padding()
        .toolbar {
            ToolbarItem {
                Button {
                    viewModel.apply(.addPlanDetail)
                } label: {
                    Image(systemName: "plus")
                }
                
            }
        }
        
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

//struct planDetialEditView: View {
//    
//    var body: some View {
//        ScrollView {
//            VStack {
//                TextField("문서 제목", text: $viewModel.title)
//                    .font(.title)
//                    .frame(height: 44)
//                    .padding()
//                    .background(Color(UIColor.systemGray6))
//                    .clipShape(RoundedRectangle(cornerRadius: 12))
//                    .padding(.horizontal)
//            }
//            categorySection()
//
//        }
//    }
//    
//    private func sectionHeader(section: AddTravelTicketSectionType) -> some View {
//        HStack {
//            ZStack {
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(Color(uiColor: .systemGray5))
//                    .frame(width: 50,
//                           height: 50)
//                
//                Image(systemName: section.icon)
//                    .resizable()
//                    .frame(width: 28,
//                           height: 28)
//            }
//            
//            Text(section.text)
//                .font(.title2)
//                .bold()
//        }
//        .padding()
//        
//    }
//    
//    private func categorySection() -> some View {
//        VStack {
//            HStack {
//                sectionHeader(section: .category)
//                Spacer()
//            }
//            ScrollView(.horizontal) {
//                LazyHStack(content: {
//                    ForEach(TravelDocumentType.allCases, id: \.rawValue) { type in
//                        let isSelected = viewModel.selecteddocumentType == type
//                        categoryCell(category: type)
//                            .background(isSelected ? Color.blue : Color(uiColor: .systemGray3) )
//                            .clipShape(RoundedRectangle(cornerRadius: 12))
//                            .onTapGesture {
//                                viewModel.apply(.selectDocumentType(type))
//                            }
//                    }
//                })
//                .padding()
//            }
//        }
//        .background(Color(uiColor: .systemGray6))
//        .clipShape(RoundedRectangle(cornerRadius: 12))
//        .padding()
//    }
//    
//    private func categoryCell(category: TravelDocumentType) -> some View {
//        HStack {
//            Text(category.text)
//                .font(.title)
//                .bold()
//                .padding()
//            Spacer()
//            ZStack {
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(.gray)
//                    .frame(width: 44, height: 44)
//                
//                Image(systemName: category.icon)
//                    .resizable()
//                    .frame(width: 32, height: 32)
//                    
//            }
//            .padding()
//        }
//    }
//}

#Preview {
    TravelPlanView(viewModel: TravelPlanDetailViewModel())
}
