//
//  TravelTicketView.swift
//  Polarnal
//
//  Created by 최승범 on 12/23/24.
//

import SwiftUI

struct TravelTicketView: View {
    private let gridItems = GridItem(.flexible(), spacing: 16)
    
    var body: some View {
        ScrollView {
            let columns = Array(repeating: gridItems, count: 2)
            LazyVGrid(columns: columns, spacing: 20) {
                
                
                TravelTicketCell()
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                TravelTicketCell()
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
            }
            .padding(.horizontal, 16)
        }
        .toolbar {
            ToolbarItem {
                Button {
//                    viewModel.apply(.showAddTravelCostView)
                } label: {
                    Image(systemName: "plus")
                }
                
            }
        }
    }
}

struct TravelTicketCell: View {
    var body: some View {
        VStack {
            HStack {
                Text("인천 -> 도쿄")
                    .font(.title)
                    .bold()
                    .padding([.horizontal, .top])
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.gray)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "airplane")
                        .resizable()
                        .frame(width: 32, height: 32)
                        
                }
                .padding([.horizontal, .top])
            }
            
            Image(.ex)
                .resizable()
                .frame(maxHeight: 200)
                .scaledToFill()
                .padding()
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
        }
       
    }
}

#Preview {
    TravelTicketView()
}
