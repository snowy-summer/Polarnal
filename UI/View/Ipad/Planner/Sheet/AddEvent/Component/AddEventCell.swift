//
//  AddEventCell.swift
//  Polarnal
//
//  Created by 최승범 on 12/13/24.
//

#if os(iOS)
import SwiftUI

struct AddEventCell: View {
    
    let type: AddEventCellType
    
    init(type: AddEventCellType) {
        self.type = type
    }
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.customGray5)
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
            case .category:
                Spacer()
            default:
                EmptyView()
            }
        }
        .padding()
    }
}
#endif
