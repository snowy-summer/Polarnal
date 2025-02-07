//
//  AddDDayView.swift
//  MacPolarnal
//
//  Created by 최승범 on 2/6/25.
//

import SwiftUI
import SwiftData

struct AddDDayView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Query var eventCategoryList: [EventCategoryDB]
    @ObservedObject private var viewModel: AddDDayViewModel
    
    init(viewModel: AddDDayViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        ScrollView {
            VStack {
                Text("New D-Day")
                    .font(.headline)
                    .padding(.vertical, 16)
                
                TextField("Name", text: $viewModel.ddayTitle)
                    .font(.title3)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                
                VStack {
                    AddDDayCell(type: .plusOrMinus)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    HStack(spacing: 40) {
                        Button(action: {
                            viewModel.apply(.selectDDay)
                        }, label: {
                            HStack {
                                if viewModel.isDDay{
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                } else {
                                    Image(systemName: "circle.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                                
                                Text("D-Day")
                                    .font(.caption)
                                    .bold()
                            }
                            .padding()
                            .background(Color.customGray5)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        })
                        .buttonStyle(.plain)
                        
                        Button(action: {
                            viewModel.apply(.selectDPlus)
                        }, label: {
                            HStack {
                                if viewModel.isDPlus{
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                } else {
                                    Image(systemName: "circle.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                                
                                Text("D +")
                                    .font(.caption)
                                    .bold()
                            }
                            .padding()
                            .background(Color.customGray5)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        })
                        .buttonStyle(.plain)
                    }
                    .padding()
                }
                .background(Color.customGray6)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal)
                
                VStack {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.customGray5)
                                .frame(width: 32,
                                       height: 32)
                            
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 20,
                                       height: 20)
                        }
                        
                        Text("카테고리")
                            .font(.title3)
                        
                        
                        Text("\(viewModel.selectedCategory?.title ?? "")")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .padding(.horizontal)
                        
                        Spacer()
                        Toggle("",isOn: $viewModel.showCategory)
                            .labelsHidden()
                    }
                    .padding(16)
                    
                    if viewModel.showCategory {
                        Divider()
                            .padding(.horizontal)
                        
                        List {
                            ForEach(eventCategoryList,
                                    id: \.id) { category in
                                EventCategoryListCell(category: category)
                                    .onTapGesture {
                                        viewModel.apply(.selectCategory(category))
                                    }
                            }
                        }
                        .frame(height: 200)
                    }
                    
                    
                    
                }
                .background(Color.customGray6)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal)
                
                
                HStack {
                    AddDDayCell(type: .startDay)
                    DatePicker("", selection: $viewModel.startDate,
                               displayedComponents: .date)
                    .labelsHidden()
                    .environment(\.locale, Locale(identifier: "ko_KR"))
                    Spacer()
                }
                .background(Color.customGray6)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal)
                
                if viewModel.isDDay {
                    HStack {
                        AddDDayCell(type: .goalDay)
                        DatePicker("", selection: $viewModel.goalDate,
                                   displayedComponents: .date)
                        .labelsHidden()
                        .environment(\.locale, Locale(identifier: "ko_KR"))
                        Spacer()
                    }
                    .background(Color.customGray6)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal)
                }
            }
        }
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext))
        }
        
        Divider()
        
        HStack {
            
            Button("Cancel") {
                dismiss()
            }
            
            Spacer()
            
            Button("Save") {
                viewModel.apply(.saveDday)
                dismiss()
            }
            .disabled(viewModel.ddayTitle.isEmpty)
            
        }
        .padding()
        
        
    }
}
