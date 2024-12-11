//
//  AddDDayCategoryCell.swift
//  Polarnal
//
//  Created by 최승범 on 12/11/24.
//

import SwiftUI

struct DDayCategoryCell: View {
    
    let category: EventCategoryDB
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 32, height: 32)
                .foregroundStyle(category.color.convertToColor())
            
            Text(category.title)
                .bold()
                .padding(.leading, 8)
            
            Spacer()
        }
    }
}
