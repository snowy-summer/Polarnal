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
        VStack {
            ScrollView {
                VStack {
                    
                    TextField("일정 내용", text: $viewModel.eventContent)
                        .font(.title)
                        .textFieldStyle(.squareBorder)
                        .frame(height: 44)
                        .padding()
                    
                    categorySection()
                    periodToggleSection()
                }
                
                
            }
            
            Divider()
            
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                
                Spacer()
                
                Button("Save") {
                    viewModel.apply(.saveEvent)
                    dismiss()
                }
                .disabled(viewModel.eventContent.isEmpty)
                
            }
            .padding()
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
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: viewModel.selectedCategory?.colorCode ?? "#FFFFFF"))
                    .frame(width: 32,
                           height: 32)
                
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
                        .padding(.horizontal)
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .frame(height: 200)
        }
        .background(Color.customGray6)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func periodToggleSection() -> some View {
        VStack {
            
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.customGray5)
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: AddEventCellType.period.icon)
                        .resizable()
                        .frame(width: 16, height: 16)
                }
                .padding(.leading)
                
                Text(AddEventCellType.period.text)
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Toggle(isOn: $viewModel.isPeriod) {
                    
                }
                .padding(.horizontal)
            }
            .padding(.top)
            
            Divider()
                .padding(.horizontal)
            
            datePickerSection(title: "시작 날짜:", date: $viewModel.startDate)
            
            if viewModel.isPeriod {
                datePickerSection(title: "목표 날짜:", date: $viewModel.goalDate)
            }
        }
        .background(Color.customGray6)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal)
        
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

