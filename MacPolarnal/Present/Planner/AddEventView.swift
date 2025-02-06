//
//  AddEventView.swift
//  MacPolarnal
//
//  Created by 최승범 on 2/6/25.
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
                    .background(Color.customGray6)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
                
                categorySection()
                periodToggleSection()
            }
            
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                
                Spacer()
                
                Button("Add Folder") {
                    viewModel.apply(.saveEvent)
                    dismiss()
                }
                .disabled(viewModel.eventContent.isEmpty)
                
            }
        }
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext))
        }
        .navigationTitle("일정 생성")
        
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
        .background(Color.customGray6)
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
                            .fill(Color.customGray5)
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
        .background(Color.customGray6)
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

