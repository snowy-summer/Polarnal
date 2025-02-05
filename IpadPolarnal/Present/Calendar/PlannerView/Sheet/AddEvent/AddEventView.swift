//
//  AddEventView.swift
//  Polarnal
//
//  Created by 최승범 on 12/13/24.
//

import SwiftUI
import SwiftData

struct AddEventView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Query var eventCategoryList: [EventCategoryDB]
    @ObservedObject private var viewModel: AddEventViewModel
    
    init(viewModel: AddEventViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                TextField("내용", text: $viewModel.eventContent)
                    .font(.title)
                    .frame(height: 44)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
                
                categorySection()
                periodToggleSection()
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
                    viewModel.apply(.saveEvent)
                    dismiss()
                }) {
                    Text("저장")
                }
            }
        }
        
    }
}

extension AddEventView {
    
    private func categorySection() -> some View {
        VStack {
            HStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: viewModel.selectedCategory?.colorCode ?? "#FFFFFF"))
                    .frame(width: 40,
                           height: 40)
            
                Text(AddEventCellType.category.text)
                .font(.title2)
                .bold()
                
                Text("\(viewModel.selectedCategory?.title ?? "")")
                    .font(.title3)
                    .foregroundStyle(.gray)
                    .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            
            Divider()
                .padding(.horizontal)
            
            List {
                ForEach(eventCategoryList, id: \.id) { category in
                    EventCategoryListCell(category: category)
                        .onTapGesture {
                            viewModel.apply(.selectCategory(category))
                        }
                }
            }
            .frame(height: 200)
        }
        .background(Color(uiColor: .systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal, 40)
        .padding(.top, 40)
    }
    
    @ViewBuilder
    private func periodToggleSection() -> some View {
        VStack {
            Toggle(isOn: $viewModel.isPeriod) {
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(uiColor: .systemGray5))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: AddEventCellType.period.icon)
                            .resizable()
                            .frame(width: 28, height: 28)
                    }
                    
                    Text(AddEventCellType.period.text)
                        .font(.title2)
                        .bold()
                }
            }
            .padding()
            
            Divider()
                .padding(.horizontal)
            
            datePickerSection(title: "시작 날짜:", date: $viewModel.startDate)
            
            if viewModel.isPeriod {
                datePickerSection(title: "목표 날짜:", date: $viewModel.goalDate)
            }
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

#Preview {
    AddEventView(viewModel: AddEventViewModel(eventData: nil))
}

enum AddEventCellType: CaseIterable {
    case category
    case period
    case eventRepeat
    case settingDDay
    
    var text: String {
        switch self {
        case .category:
            return "카테고리"
            
        case .period:
            return "기간"
            
        case .eventRepeat:
            return "반복"
            
        case .settingDDay:
            return "D-Day 설정"
        }
    }
    
    var icon: String {
        switch self {
        case .category:
            return "star.fill"
            
        case .period:
            return "star.fill"
            
        case .eventRepeat:
            return "star.fill"
            
        case .settingDDay:
            return "star.fill"
        }
    }
}



