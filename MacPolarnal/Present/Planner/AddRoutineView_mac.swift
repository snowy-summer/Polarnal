//
//  AddRoutineView_mac.swift
//  Polarnal
//
//  Created by 최승범 on 2/19/25.
//

import SwiftUI
import SwiftData

#if os(macOS)
struct AddRoutineView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @ObservedObject private var viewModel: AddRoutineViewModel
    
    init(viewModel: AddRoutineViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                TextField("Name", text: $viewModel.routineName)
                    .font(.title2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    
                selectRepeatDaysView()
                    .padding(.horizontal)
                
                ColorPalettePartView(selctedColor: $viewModel.routineColor)
                    .background(Color.customGray6)
                    .cornerRadius(12)
                    .padding(.horizontal)
                
            }
        }
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext))
        }
        .navigationTitle("Create Routine")
        
        Divider()
        
        HStack {
            
            Button("Cancel") {
                dismiss()
            }
            
            Spacer()
            
            Button("Save") {
                viewModel.apply(.saveRoutine)
                dismiss()
            }
            .disabled(viewModel.saveDisabled)
            
        }
        .padding()
        
    }
    
    private func selectRepeatDaysView() -> some View {
        VStack {
            HStack {
                Text("Select days")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            
            Divider()
            
            gridDaysView()
        }
        .padding()
        .background(Color.customGray6)
        .cornerRadius(12)
    }
    
    private func gridDaysView() -> some View {
        let gridItems = GridItem(.flexible(),
                                 spacing: 4)
        let columns = Array(repeating: gridItems,
                            count: 7)
        return LazyVGrid(columns: columns, spacing: 4) {
            ForEach(Day.allCases, id: \.self) { day in
                let isSelected = viewModel.isSelected(day: day)
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.customGray5, lineWidth: 4)
                    .fill(isSelected ? Color.customGray5 : Color.customGray6)
                    .frame(width: 44,
                           height: 44)
                    .overlay {
                        Text(day.name)
                            .font(.callout)
                            .bold()
                    }
                    .padding(.horizontal, 8)
                    .onTapGesture {
                        viewModel.apply(.selectRepeatDay(day))
                    }
                
            }
        }
    }
    
}
#endif
