//
//  AddTravelCostView.swift
//  Polarnal
//
//  Created by 최승범 on 12/18/24.
//

import SwiftUI
import SwiftData

struct AddTravelCostView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @StateObject private var viewModel: AddTravelCostViewModel
    
    init(cost: TravelCostDB?) {
        self._viewModel = StateObject(wrappedValue: AddTravelCostViewModel(receipt: cost))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    
                    HStack {
                        totalReceiptCard()
                            .frame(width: geometry.size.width / 3)
                            .background(Color(uiColor: .systemGray5))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        Spacer()
                        VStack {
                            ZStack {
                                VStack(spacing: 20) {
                                    costCard(cost: $viewModel.spentCost,
                                             type: viewModel.spentCostType)
                                    .padding()
                                    .frame(height: 140)
                                    .background(Color(uiColor: .systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .padding(.horizontal)
                                    
                                    costCard(cost: $viewModel.convertedCost,
                                             type: viewModel.convertedCostType)
                                    .padding()
                                    .frame(height: 140)
                                    .background(Color(uiColor: .systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .padding(.horizontal)
                                }
                                Button(action: {
                                    
                                }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(uiColor: .systemGray3))
                                            .frame(width: 70, height: 70)
                                        Image(systemName: "repeat")
                                            .resizable()
                                            .frame(width: 44, height: 44)
                                    }
                                    
                                    
                                })
                            }
                            Button(action: {
                                
                            }, label: {
                                Text("발행")
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color(uiColor: .systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .padding(.top)
                                    .padding(.horizontal)
                                
                            })
                            
                        }
                    }
                    .frame(height: 400)
                    .padding()
                }
                
                HStack {
                    sectionHeader(section: .day)
                    DatePicker("", selection: $viewModel.spentDate,
                               displayedComponents: .date)
                    .labelsHidden()
                    .environment(\.locale, Locale(identifier: "ko_KR"))
                    Spacer()
                }
                .background(Color(uiColor: .systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
                
                HStack {
                    sectionHeader(section: .content)
                    TextField("간단한 내용", text: $viewModel.costDescription)
                        .padding()
                        .frame(height: 60)
                        .font(.title3)
                        .bold()
                        .background(Color(uiColor: .systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    Spacer()
                }
                .background(Color(uiColor: .systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
                
                costSection()
                    .background(Color(uiColor: .systemGray3))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding()
                
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 600)
                    .padding()
            }
        }
    }
    
    private func totalReceiptCard() -> some View {
        VStack {
            
            Text("영수증")
                .font(.largeTitle)
                .bold()
                .padding()
            DottedLine()
                .stroke(style: StrokeStyle(lineWidth: 4,
                                           dash: [16, 8])) // 길이의 점선과 공백을 번갈아 적용
                .frame(height: 2)
                .padding(.horizontal)
            
            HStack {
                Text("₩")
                    .font(.largeTitle)
                    .bold()
                Text("1,842,214")
                    .font(.largeTitle)
                    .bold()
            }
            .padding()
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("날짜:")
                            .font(.title3)
                            .foregroundStyle(.gray)
                        Text(viewModel.dateString)
                            .font(.title3)
                    }
                    .padding(8)
                    
                    HStack {
                        Text("종류:")
                            .font(.title3)
                            .foregroundStyle(.gray)
                        Text(viewModel.selectedCostType.title)
                            .font(.title3)
                    }
                    .padding(8)
                    
                    HStack {
                        Text("내용:")
                            .font(.title3)
                            .foregroundStyle(.gray)
                        Text(viewModel.costDescription)
                            .font(.title3)
                    }
                    .padding(8)
                }
                .padding()
                Spacer()
            }
            
            Spacer()
        }
    }
    
    private func sectionHeader(section: AddTravelCostSectionType) -> some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(uiColor: .systemGray5))
                    .frame(width: 50,
                           height: 50)
                
                Image(systemName: section.icon)
                    .resizable()
                    .frame(width: 28,
                           height: 28)
            }
            
            Text(section.text)
                .font(.title2)
                .bold()
        }
        .padding()
        
    }
    
    private func costCard(cost: Binding<String>, type: String) -> some View {
        HStack {
            Button(action: {
                
            }, label: {
                HStack {
                    Text(type)
                        .font(.title)
                        .bold()
                    Image(systemName: "chevron.down")
                }
            })
            .padding()
            .background(Color(uiColor: .systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            TextField("돈",text: cost)
                .font(.title)
                .bold()
        }
        
    }
    
    private func costSection() -> some View {
        ScrollView(.horizontal) {
            VStack {
                HStack {
                    ForEach(TravelCostType.allCases.prefix(5),
                            id: \.self) { costType in
                        costTypeCell(type: costType)
                    }
                }
                .padding(.bottom, 16)
                
                HStack {
                    ForEach(TravelCostType.allCases.suffix(from: 5),
                            id: \.self) { costType in
                        costTypeCell(type: costType)
                    }
                }
            }
            .padding(20)
        }
    }
    
    private func costTypeCell(type: TravelCostType) -> some View {
        let isSelected = type == viewModel.selectedCostType
        
        return ZStack {
            
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? .black : .clear)
                .frame(width: 260, height: 160)
            
            VStack {
                HStack {
                    Image(systemName: type.icon)
                        .resizable()
                        .frame(width: 50, height: 50)
                    Spacer()
                }
                .padding()
                
                HStack{
                    Spacer()
                    
                    Text(type.title)
                        .font(.title)
                        .bold()
                }
                .padding()
            }
            .frame(width: 250, height: 150)
            .background(Color(uiColor: .systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 8)
            .onTapGesture {
                viewModel.apply(.selectCostType(type))
            }
        }
    }
}

enum AddTravelCostSectionType {
    case day
    case content
    case photo
    
    var icon: String {
        switch self {
        case .day:
            return "calendar"
        case .content:
            return "note.text"
        case .photo:
            return "photo"
        }
    }
    
    var text: String {
        switch self {
        case .day:
            return "날짜"
        case .content:
            return "내용"
        case .photo:
            return "사진"
        }
    }
}

#Preview {
    AddTravelCostView(cost: nil)
}
