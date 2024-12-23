//
//  AddTravelTicketView.swift
//  Polarnal
//
//  Created by 최승범 on 12/23/24.
//

import SwiftUI
import SwiftData

struct AddTravelTicketView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var selectedTravelViewModel: SelectedTravelViewModel
    @StateObject private var viewModel: AddTravelTicketViewModel
    
    init(document: TravelDocumentDB?) {
        self._viewModel = StateObject(wrappedValue: AddTravelTicketViewModel(document: document))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                TextField("문서 제목", text: $viewModel.title)
                    .font(.title)
                    .frame(height: 44)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 40)
            }
            
            photoSection()
                .padding(.horizontal, 40)
        }
        
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Text("취소")
                }
                
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.apply(.enrollDocument)
                    dismiss()
                }) {
                    Text("저장")
                }
            }
        }
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext, selectedTravelViewModel.selectedTravelId))
        }
    }
    
    private func sectionHeader(section: AddTravelTicketSectionType) -> some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(uiColor: .systemGray5))
                    .frame(width: 50,
                           height: 50)
                
                Image(systemName: section.icon)
                    .resizable()
                    .frame(width: 28,
                           height: 28)
            }
            
            Text(section.text)
                .font(.title2)
                .bold()
        }
        .padding()
        
    }
    
    private func photoSection() -> some View {
        VStack {
            HStack {
                sectionHeader(section: .photo)
                Spacer()
                Button(action: {
                    
                }, label: {
                    Image(systemName: "plus")
                        .resizable()
                        .tint(.black)
                        .frame(width: 28, height: 28)
                        .bold()
                    
                    
                })
                .padding(.trailing, 40)
            }
            ScrollView(.horizontal) {
                LazyHStack {
                    Image(.ex)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            
        }
        .background(Color(uiColor: .systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding()
        
    }
    
}

enum AddTravelTicketSectionType {
    case category
    case photo
    
    var icon: String {
        switch self {
        case .category:
            return "note.text"
        case .photo:
            return "photo"
        }
    }
    
    var text: String {
        switch self {
        case .category:
            return "종류"
        case .photo:
            return "사진"
        }
    }
}

#Preview {
    AddTravelCostView(cost: nil)
}
