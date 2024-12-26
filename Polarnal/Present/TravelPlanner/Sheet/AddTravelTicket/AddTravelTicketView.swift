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
                    .padding(.horizontal)
            }
            categorySection()
            photoSection()
            
            LazyVStack {
                ForEach(viewModel.imageList, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .scaledToFit()
                        .padding()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.apply(.enrollDocument)
                    dismiss()
                }) {
                    Text("저장")
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowPhotopicker) {
            PhotoPicker(selectedImages: $viewModel.imageList)
        }
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext,
                                                selectedTravelViewModel.selectedTravel?.id))
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
    
    private func categorySection() -> some View {
        VStack {
            HStack {
                sectionHeader(section: .category)
                Spacer()
            }
            ScrollView(.horizontal) {
                LazyHStack(content: {
                    ForEach(TravelDocumentType.allCases, id: \.rawValue) { type in
                        let isSelected = viewModel.selecteddocumentType == type
                        categoryCell(category: type)
                            .background(isSelected ? Color.blue : Color(uiColor: .systemGray3) )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .onTapGesture {
                                viewModel.apply(.selectDocumentType(type))
                            }
                    }
                })
                .padding()
            }
        }
        .background(Color(uiColor: .systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding()
    }
    
    private func categoryCell(category: TravelDocumentType) -> some View {
        HStack {
            Text(category.text)
                .font(.title)
                .bold()
                .padding()
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray)
                    .frame(width: 44, height: 44)
                
                Image(systemName: category.icon)
                    .resizable()
                    .frame(width: 32, height: 32)
                    
            }
            .padding()
        }
    }
    
    private func photoSection() -> some View {
        VStack {
            HStack {
                sectionHeader(section: .photo)
                Spacer()
                Button(action: {
                    viewModel.apply(.showAddPhotoPicker)
                }, label: {
                    Image(systemName: "plus")
                        .resizable()
                        .tint(.black)
                        .frame(width: 28, height: 28)
                        .bold()
                    
                    
                })
                .padding(.trailing, 40)
            }
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
    AddTravelTicketView(document: nil)
}
