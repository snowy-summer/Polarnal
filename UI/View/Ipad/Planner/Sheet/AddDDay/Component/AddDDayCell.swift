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
#if os(macOS)
//                RoundedRectangle(cornerRadius: 8)
//                    .fill(Color.customGray5)
//                    .frame(width: 32,
//                           height: 32)
//                
//                Image(systemName: type.icon)
//                    .resizable()
//                    .frame(width: 20,
//                           height: 20)
                #else
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(Color.customGray5)
//                    .frame(width: 50,
//                           height: 50)
//                
//                Image(systemName: type.icon)
//                    .resizable()
//                    .frame(width: 28,
//                           height: 28)
//                
#endif
            }
            
#if os(macOS)
            Text(type.text)
                .font(.title3)
#else
            Text(type.text)
                .font(.title2)
                .bold()
#endif
            
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
