//
//  AddDDayCategoryCell.swift
//  Polarnal
//
//  Created by 최승범 on 12/11/24.
//

import SwiftUI

struct EventCategoryListCell: View {
    
    let category: EventCategoryDB
    
    var body: some View {
        HStack {
#if os(macOS)
            RoundedRectangle(cornerRadius: 4)
                .frame(width: 20, height: 20)
                .foregroundStyle(Color(hex: category.colorCode))
            #else
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 32, height: 32)
                .foregroundStyle(Color(hex: category.colorCode))
#endif
            
            Text(category.title)
                .bold()
                .padding(.leading, 8)
            
            Spacer()
        }
    }
}
