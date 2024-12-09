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
                .frame(width: 50,
                       height: 50)
                
            
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(uiColor: .systemGray5))
                .frame(width: 50,
                       height: 50)
                
            
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(uiColor: .systemGray5))
                .frame(width: 50,
                       height: 50)
                
            Spacer()
        }
    }
    
}
