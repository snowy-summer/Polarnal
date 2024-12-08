//
//  SideTabBarView.swift
//  Polarnal
//
//  Created by 최승범 on 12/8/24.
//

import SwiftUI

struct SideTabBarView: View {
    
    var body: some View {
        VStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(uiColor: .systemGray5))
                .frame(width: 60,
                       height: 60)
                
            
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(uiColor: .systemGray5))
                .frame(width: 60,
                       height: 60)
                
            
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(uiColor: .systemGray5))
                .frame(width: 60,
                       height: 60)
                
            Spacer()
        }
    }
    
}
