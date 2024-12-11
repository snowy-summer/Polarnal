//
//  AddDDayView.swift
//  Polarnal
//
//  Created by 최승범 on 12/11/24.
//

import SwiftUI
import SwiftData

struct AddDDayView: View {
    @Environment(\.dismiss) var dismiss
    @Query var eventCategoryList: [EventCategoryDB]
    @StateObject private var viewModel: AddDDayViewModel = AddDDayViewModel(eventCategory: nil)
    
    var body: some View {
        ScrollView {
            VStack {
                TextField("제목", text: $viewModel.ddayTitle)
                    .font(.title)
                    .frame(height: 44)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
                
                HStack {
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
                                .background(Color(uiColor: .systemGray5))
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
                                .background(Color(uiColor: .systemGray5))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            })
                        }
                        .padding()
                    }
                    
                    
                }
                .background(Color(uiColor: .systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 40)
                .padding(.top, 40)
                
                HStack {
                    VStack {
                        Toggle(isOn: $viewModel.showCategory) {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(uiColor: .systemGray5))
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
                            }
                        }
                        
                        .padding()
                        
                        if viewModel.showCategory {
                            Divider()
                                .padding(.horizontal)
                            
                            List {
                                ForEach(eventCategoryList,
                                        id: \.id) { category in
                                    DDayCategoryCell(category: category)
                                }
                            }
                            .frame(height: 200)
                        }
                    }
                    
                    
                }
                .background(Color(uiColor: .systemGray6))
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
                .background(Color(uiColor: .systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 40)
                .padding(.top, 40)
                
                if viewModel.isDDay {
                    HStack {
                        AddDDayCell(type: .goalDay)
                        DatePicker("", selection: $viewModel.startDate,
                                   displayedComponents: .date)
                        .labelsHidden()
                        .environment(\.locale, Locale(identifier: "ko_KR"))
                        Spacer()
                    }
                    .background(Color(uiColor: .systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 40)
                    .padding(.top, 40)
                }
            }
            
        }
        .padding(.bottom, 40)
        .navigationTitle("D-Day 생성")
        .navigationBarTitleDisplayMode(.inline)
        //        .toolbar {
        //
        //            ToolbarItem(placement: .topBarLeading) {
        //                Button(action: {
        //                    dismiss()
        //                }) {
        //                    Text("취소")
        //                }
        //            }
        //
        //            ToolbarItem(placement: .topBarTrailing) {
        //                Button(action: {
        //                    viewModel.apply(.sa)
        //                    dismiss()
        //                }) {
        //                    Text("저장")
        //                }
        //            }
        //        }
    }
}

#Preview {
    AddDDayView()
}

enum AddDDayCellType: CaseIterable {
    case plusOrMinus
    case category
    case startDay
    case goalDay
    
    var text: String {
        switch self {
        case .plusOrMinus:
            return "종류"
            
        case .category:
            return "카테고리"
            
        case .startDay:
            return "시작 날짜"
            
        case .goalDay:
            return "목표 날짜"
        }
    }
    
    var icon: String {
        switch self {
        case .plusOrMinus:
            return "star.fill"
            
        case .category:
            return "star.fill"
            
        case .startDay:
            return "star.fill"
            
        case .goalDay:
            return "star.fill"
        }
    }
}


