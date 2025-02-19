//
//  RoutineView.swift
//  Polarnal
//
//  Created by 최승범 on 2/19/25.
//

import SwiftUI
import SwiftData

struct RoutineView: View {
    @Environment(\.modelContext) var modelContext
    @Query var routineList: [RoutineDB]
    
    @StateObject private var viewModel: DDayViewModel = DDayViewModel()
    private let gridItems = GridItem(.flexible(), spacing: 16)
    
    var body: some View {
        ScrollView {
            let columns = Array(repeating: gridItems,
                                count: 3)
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(routineList,
                        id: \.id) { routine in
                    RoutineCell(routineDB: routine)
                        .background(Color.customGray5)
                        .frame(height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(radius: 5, x: 2, y:2)
                        .onTapGesture {
//                            viewModel.apply(.showEditView(dday))
                        }
                }
            }
            .padding(.top, 8)
        }
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext))
        }
        .sheet(item: $viewModel.selectedDDay) { dday in
            NavigationStack {
                AddDDayView(viewModel: AddDDayViewModel(dday: dday))
            }
        }
        .padding()
    }
}

struct RoutineCell: View {
    
    let routineDB: RoutineDB
    let dateManager = DateManager.shared
    
    var body: some View {
        VStack {
            Text(routineDB.name)
                .font(.title2)
                .bold()
            
            gridView()
                .padding()
            
            HStack {
                Button("Done") {
                    
                }
                
                Divider()
                HStack {
                    Image(systemName: "flame.fill")
                        .tint(.red)
                    Text("\(routineDB.routineItems?.count ?? 0)")
                }
            }
            
            
        }
        
        //        HStack {
        //
        //            VStack(alignment: .leading) {
        //                Text(dDay.title)
        //                    .font(.title)
        //                    .bold()
        //
        //                if DDayType(rawValue: dDay.type) == .DDay {
        //                    Text(dateManager.getDateString(date: dDay.goalDate))
        //                } else {
        //                    Text(dateManager.getDateString(date: dDay.startDate))
        //                }
        //                Spacer()
        //            }
        //            .padding()
        //
        //            VStack {
        //                Spacer()
        //                HStack {
        //
        //                    if DDayType(rawValue: dDay.type) == .DDay {
        //                        Text(dateManager.calculateDDay(startDay: dDay.startDate,
        //                                                       goalDay: dDay.goalDate))
        //                        .font(.title)
        //                        .bold()
        //                        .padding()
        //                    } else {
        //                            Text(dateManager.calculateDPlus(startDay: dDay.startDate))
        //                            .font(.title)
        //                            .bold()
        //                            .padding()
        //                    }
        //                }
        //            }
        //        }
        
    }
    
    @ViewBuilder
    func gridView() -> some View {
        if let routineItems = routineDB.routineItems {
            let gridItems = GridItem(.flexible(),
                                     spacing: 4)
            let columns = Array(repeating: gridItems,
                                count: 10)
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(routineItems, id: \.id) { item in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: routineDB.colorCode))
                }
            }
        } else {
            EmptyView()
        }
    }
}

#Preview {
    DDayView()
}
