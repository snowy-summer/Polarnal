//
//  DDayView.swift
//  Polarnal
//
//  Created by 최승범 on 12/10/24.
//

import SwiftUI

struct DDayView: View {
    
    private let columns = Array(repeating: GridItem(.flexible()),
                                count: 2)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            DDayCell()
                .background(Color(uiColor: .systemGray5))
                .frame(height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .shadow(radius: 5)
            DDayCell()
                .background(Color(uiColor: .systemGray5))
                .frame(height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .shadow(radius: 5)
        }
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
//                    Image(systemName: "pencil")
//                        .resizable()
//                        .frame(width: 32,
//                               height: 32)
//                        .padding()
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
