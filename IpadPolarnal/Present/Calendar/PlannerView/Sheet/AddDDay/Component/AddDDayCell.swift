//
//  AddDDayCell.swift
//  Polarnal
//
//  Created by 최승범 on 12/11/24.
//

import SwiftUI

struct AddDDayCell: View {
    
    let type: AddDDayCellType
    
    init(type: AddDDayCellType) {
        self.type = type
    }
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(uiColor: .systemGray5))
                    .frame(width: 50,
                           height: 50)
                
                Image(systemName: type.icon)
                    .resizable()
                    .frame(width: 28,
                           height: 28)
            }
            
            Text(type.text)
                .font(.title2)
                .bold()
            
            switch type {
            case .plusOrMinus:
                Spacer()
            case .category:
                Spacer()
            default:
                EmptyView()
            }
        }
        .padding()
    }
}
