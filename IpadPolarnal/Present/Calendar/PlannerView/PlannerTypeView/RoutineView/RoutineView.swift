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
                    RoutineCell(viewModel: RoutineCellViewModel(routine: routine))
                        .background(Color.customGray5)
                        .frame(height: 200)
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
                AddRoutineView(viewModel: AddRoutineViewModel(routine: nil))
            }
        }
        .padding()
    }
}

struct RoutineCell: View {
    @Environment(\.modelContext) var modelContext
    private let viewModel: RoutineCellViewModel
    
    init(viewModel: RoutineCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text(viewModel.routineDB.name)
                .font(.title2)
                .bold()
                .padding(.top)
            
            gridView()
                .padding(.horizontal)
            
            HStack {
               
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(.red)
                    Text("\(viewModel.streakCount)")
                }
                .padding(.horizontal)
                
                Divider()
                
                Button("Done") {
                    viewModel.apply(.doenTodayRoutine)
                }
                .disabled(viewModel.isDoneDisabled)
                .padding(.horizontal)
            }
            .padding(.vertical)
            
            
        }
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext))
        }
        
    }
    
    @ViewBuilder
    func gridView() -> some View {
        if let routineItems = viewModel.routineDB.routineItems {
            let gridItems = GridItem(.fixed(24),
                                     spacing: 4)
            let columns = Array(repeating: gridItems,
                                count: 10)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 4) {
                    ForEach(routineItems, id: \.id) { item in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(item.isDone ? Color(hex: viewModel.routineDB.colorCode) : Color.customGray6)
                            .frame(height: 24)
                    }
                }
            }
            .frame(height: 92)
        } else {
            EmptyView()
        }
    }
    
}

#Preview {
    RoutineView()
}
