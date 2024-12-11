//
//  DDayView.swift
//  Polarnal
//
//  Created by 최승범 on 12/10/24.
//

import SwiftUI

struct DDayView: View {
    
    private let gridItems = GridItem(.flexible(), spacing: 16)
    
   
    
    var body: some View {
        ScrollView {
            let columns = Array(repeating: gridItems,
                                count: 3)
            LazyVGrid(columns: columns, spacing: 16) {
                DDayCell()
                    .background(Color(uiColor: .systemGray5))
                    .frame(height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(radius: 5, x: 2, y:2)
                DDayCell()
                    .background(Color(uiColor: .systemGray5))
                    .frame(height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(radius: 5, x: 2, y:2)
                
                DDayCell()
                    .background(Color(uiColor: .systemGray5))
                    .frame(height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(radius: 5, x: 2, y:2)
            }
        }
        .padding()
    }
}

struct DDayCell: View {
    var body: some View {
        HStack {
            
            VStack(alignment: .leading) {
                Text("수능")
                    .font(.title)
                    .bold()
                
                Text("2024.05.13")
                Spacer()
            }
            .padding()
            
            VStack {
                
                Spacer()
                
                HStack {
                    Text("D - 100")
                        .font(.title)
                        .bold()
                        .padding()
                }
            }
        }
        
    }
}

#Preview {
    DDayView()
}
