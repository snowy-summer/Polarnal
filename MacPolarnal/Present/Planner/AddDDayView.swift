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
                TextField("제목", text: $viewModel.ddayTitle)
                    .font(.title)
                    .frame(height: 44)
                    .padding()
                    .background(Color.customGray6)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
                
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
                                        .frame(width: 30, height: 30)
                                } else {
                                    Image(systemName: "circle.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                                
                                Text("D-Day")
                                    .font(.title3)
                                    .bold()
                            }
                            .padding()
                            .background(Color.customGray5)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        })
                        
                        Button(action: {
                            viewModel.apply(.selectDPlus)
                        }, label: {
                            HStack {
                                if viewModel.isDPlus{
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                } else {
                                    Image(systemName: "circle.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                                
                                Text("D +")
                                    .font(.title3)
                                    .bold()
                            }
                            .padding()
                            .background(Color.customGray5)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        })
                    }
                    .padding()
                }
                .background(Color.customGray6)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 40)
                .padding(.top, 40)
                
                VStack {
                    Toggle(isOn: $viewModel.showCategory) {
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.customGray5)
                                    .frame(width: 50,
                                           height: 50)
                                
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .frame(width: 28,
                                           height: 28)
                            }
                            
                            Text("카테고리")
                                .font(.title2)
                                .bold()
                            
                            Text("\(viewModel.selectedCategory?.title ?? "")")
                                .font(.title3)
                                .foregroundStyle(.gray)
                                .padding(.horizontal)
                        }
                    }
                    .padding()
                    
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
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 40)
                .padding(.top, 40)
                
                
                HStack {
                    AddDDayCell(type: .startDay)
                    DatePicker("", selection: $viewModel.startDate,
                               displayedComponents: .date)
                    .labelsHidden()
                    .environment(\.locale, Locale(identifier: "ko_KR"))
                    Spacer()
                }
                .background(Color.customGray6)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 40)
                .padding(.top, 40)
                
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
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 40)
                    .padding(.top, 40)
                }
            }
            
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
        }
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext))
        }
    }
}
