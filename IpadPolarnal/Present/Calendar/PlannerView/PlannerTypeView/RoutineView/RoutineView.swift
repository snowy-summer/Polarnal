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
        GeometryReader { geometry in
            let availableWidth = geometry.size.width
#if os(macOS)
            let columnCount = max(1, Int(availableWidth / 250))
#else
            let columnCount = 3
#endif
            let columns = Array(repeating: GridItem(.flexible(), spacing: 16),
                                count: columnCount)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(routineList, id: \.id) { routine in
                        RoutineCell(viewModel: RoutineCellViewModel(routine: routine))
                            .background(Color.customGray6)
                            .frame(height: 200)
                            .frame(minWidth: 240, maxWidth: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            .shadow(radius: 2, x: 1, y:1)
                            .contextMenu {
                                Button(role: .destructive) {
                                    viewModel.apply(.deleteRoutine(routine))
                                } label: {
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
