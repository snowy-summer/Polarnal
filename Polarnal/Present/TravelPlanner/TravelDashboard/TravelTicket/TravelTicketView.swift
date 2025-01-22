//
//  TravelTicketView.swift
//  Polarnal
//
//  Created by 최승범 on 12/23/24.
//

import SwiftUI

struct TravelTicketView: View {
    @Environment(\.modelContext) var modelContext
    @ObservedObject var viewModel: TravelTicketViewModel
    @EnvironmentObject var selectedTravelViewModel: SelectedTravelViewModel
    private let gridItems = GridItem(.flexible(), spacing: 16)
    
    var body: some View {
        ScrollView {
            let columns = Array(repeating: gridItems,
                                count: viewModel.documentList.count)
            LazyVGrid(columns: columns, spacing: 20) {
                
                ForEach(viewModel.documentList, id: \.id) { ticket in
                    TravelTicketCell(document: ticket)
                        .background(Color(uiColor: .systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .contextMenu {
                            Button(role: .destructive, action: {
                                viewModel.apply(.deleteTravelTicket(ticket))
                            }) {
                                Label("문서 삭제", systemImage: "trash")
                            }
                        }
                }
                
            }
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext,
                                                selectedTravelViewModel.selectedTravel?.id))
        }
        .toolbar {
            ToolbarItem {
                NavigationLink(destination: AddTravelTicketView(document: nil)) {
                    Image(systemName: "plus")
                        .tint(Color.normalText)
                }
            }
        }
    }
}

struct TravelTicketCell: View {
    
    let document: TravelDocumentDB
    
    var body: some View {
        VStack {
            HStack {
                Text(document.title)
                    .font(.title)
                    .bold()
                    .padding([.horizontal, .top])
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.gray)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: TravelDocumentType(rawValue: document.type)?.icon ?? TravelDocumentType.flight.icon)
                        .resizable()
                        .frame(width: 32, height: 32)
                        
                }
                .padding([.horizontal, .top])
            }
            
            if !document.contentImageData.isEmpty,
               let image = UIImage(data: document.contentImageData.first!) {
                
                Image(uiImage: image)
                    .resizable()
                    .frame(maxHeight: 200)
                    .scaledToFill()
                    .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                Image(.ex)
                    .resizable()
                    .frame(maxHeight: 200)
                    .scaledToFill()
                    .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .hidden()
            }
            
        }
       
    }
}

#Preview {
    TravelTicketView(viewModel: TravelTicketViewModel())
}
