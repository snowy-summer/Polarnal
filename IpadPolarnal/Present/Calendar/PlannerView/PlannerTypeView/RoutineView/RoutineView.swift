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
    
    @StateObject private var viewModel: RoutineViewModel = RoutineViewModel()
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
                        .frame(minWidth: 240)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(radius: 3, x: 2, y:2)
                        .contextMenu {
                            Button(role: .destructive, action: {
                                viewModel.apply(.deleteRoutine(routine))
                            }) {
                                Label("삭제", systemImage: "trash")
                            }
                        }
                        .onTapGesture {
                            viewModel.apply(.showEditView(routine))
                        }
                        
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext))
        }
        .sheet(item: $viewModel.selectedRoutine) { routine in
            NavigationStack {
                AddRoutineView(viewModel: AddRoutineViewModel(routine: routine))
            }
        }
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
               
                Spacer()
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(.red)
                    Text("\(viewModel.streakCount)")
                }
                .padding(.horizontal)
                
                Spacer()
                
                Divider()
                
                Spacer()
                
                Button("Done") {
                    viewModel.apply(.doenTodayRoutine)
                }
                .tint(Color.normalText)
                .disabled(viewModel.isDoneDisabled)
                .padding(.horizontal)
                Spacer()
            }
            .padding(.vertical)
            
            
        }
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext))
        }
        
    }
    
    @ViewBuilder
    func gridView() -> some View {
        
#if os(iOS)
        let size: CGFloat = 24
        #elseif os(macOS)
        let size: CGFloat = 16
#endif
        
        if let routineItems = viewModel.routineDB.routineItems {
            let gridItems = GridItem(.fixed(size),
                                     spacing: 4)
            let columns = Array(repeating: gridItems,
                                count: 10)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 4) {
                    ForEach(routineItems, id: \.id) { item in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(item.isDone ? Color(hex: viewModel.routineDB.colorCode) : Color.customGray6)
                            .frame(height: size)
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
