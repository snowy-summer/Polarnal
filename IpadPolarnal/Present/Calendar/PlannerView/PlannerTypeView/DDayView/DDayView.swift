//
//  DDayView.swift
//  Polarnal
//
//  Created by 최승범 on 12/10/24.
//

import SwiftUI
import SwiftData

struct DDayView: View {
    @Environment(\.modelContext) var modelContext
    @Query var ddayList: [DDayDB]
    
    @StateObject private var viewModel: DDayViewModel = DDayViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width
#if os(macOS)
            let columnCount = max(1, Int(availableWidth / 200))
#else
            let columnCount = 4
#endif
            let columns = Array(repeating: GridItem(.flexible(), spacing: 16),
                                count: columnCount)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(ddayList, id: \.id) { dday in
                        DDayCell(dDay: dday)
                            .background(Color.customGray6)
                            .frame(height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            .shadow(radius: 2, x: 1, y: 1)
                            .contextMenu {
                                Button(role: .destructive) {
                                    viewModel.apply(.deleteDDay(dday))
                                } label: {
                                    Label("삭제", systemImage: "trash")
                                }
                            }
                            .onTapGesture {
                                viewModel.apply(.showEditView(dday))
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
}

struct DDayCell: View {
    
    let dDay: DDayDB
    let dateManager = DateManager.shared
    
    var body: some View {
        HStack {
            
            VStack(alignment: .leading) {
                Text(dDay.title)
                    .font(.title2)
                    .bold()
                
                if DDayType(rawValue: dDay.type) == .DDay {
                    Text(dateManager.getDateString(date: dDay.goalDate))
                } else {
                    Text(dateManager.getDateString(date: dDay.startDate))
                }
                Spacer()
            }
            .padding()
            
            VStack {
                Spacer()
                HStack {
                    
                    if DDayType(rawValue: dDay.type) == .DDay {
                        Text(dateManager.calculateDDay(startDay: dDay.startDate,
                                                       goalDay: dDay.goalDate))
                        .font(.title)
                        .bold()
                        .padding()
                    } else {
                        Text(dateManager.calculateDPlus(startDay: dDay.startDate))
                            .font(.title)
                            .bold()
                            .padding()
                    }
                }
            }
        }
        
    }
}

#Preview {
    DDayView()
}
