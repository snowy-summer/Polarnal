//
//  AddTravelPlanView.swift
//  Polarnal
//
//  Created by 최승범 on 12/16/24.
//

import SwiftUI

struct AddTravelPlanView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @ObservedObject private var viewModel: AddTravelPlanViewModel
    
    init(viewModel: AddTravelPlanViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack {
                TextField("여행 제목은 무엇일까요?", text: $viewModel.travelTitle)
                    .font(.title)
                    .frame(height: 44)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 40)
                
                destinationSection()
                
                periodSection()
            }
        }
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext))
        }
        .navigationTitle("일정 생성")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Text("취소")
                }
                
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.apply(.saveTravel)
                    dismiss()
                }) {
                    Text("저장")
                }
            }
        }
        
    }
}

extension AddTravelPlanView {
    
    private func destinationSection() -> some View {
        VStack {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(uiColor: .systemGray5))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: AddTravelSectionType.destination.icon)
                        .resizable()
                        .frame(width: 28, height: 28)
                }
                
                Text(AddTravelSectionType.destination.text + ": ")
                    .font(.title2)
                    .bold()
                
                TextField("목적지를 입력해보세요", text: $viewModel.destinationCountry)
                    .font(.title3)
                    .frame(height: 32)
                    .padding()
                    .background(Color(UIColor.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
            
        }
        .background(Color(uiColor: .systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 40)
        .padding(.top, 40)
    }
    
    @ViewBuilder
    private func periodSection() -> some View {
        VStack {
            
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(uiColor: .systemGray5))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: AddTravelSectionType.period.icon)
                        .resizable()
                        .frame(width: 28, height: 28)
                }
                
                Text(AddTravelSectionType.period.text)
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding()
            
            Divider()
                .padding(.horizontal)
            
            datePickerSection(title: "시작 날짜:", date: $viewModel.startDate)
            
            datePickerSection(title: "마지막 날짜:", date: $viewModel.endDate)
            
        }
        .background(Color(uiColor: .systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 40)
        .padding(.top, 40)
        
    }
    
    // MARK: - DatePicker Section
    @ViewBuilder
    private func datePickerSection(title: String,
                                   date: Binding<Date>) -> some View {
        HStack {
            Text(title)
                .font(.title3)
                .bold()
            
            DatePicker("", selection: date, displayedComponents: .date)
                .labelsHidden()
                .environment(\.locale, Locale(identifier: "ko_KR"))
            
            Spacer()
        }
        .padding()
    }
}

enum AddTravelSectionType: CaseIterable {
    case period
    case destination
    
    var text: String {
        switch self {
            
        case .period:
            return "기간"
            
        case .destination:
            return "목적지"
        }
    }
    
    var icon: String {
        switch self {
            
        case .period:
            return "star.fill"
            
        case .destination:
            return "map"
        }
    }
}




#Preview {
    AddTravelPlanView(viewModel: AddTravelPlanViewModel(travelPlanData: nil))
}
