//
//  TravelCostView.swift
//  Polarnal
//
//  Created by 최승범 on 12/17/24.
//

import SwiftUI

struct TravelCostView: View {
    var body: some View {
        
        VStack {
            HStack {
                RoundedRectangle(cornerRadius: 24)
                    .background(Color(uiColor: .systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding()
                
                
                
                List {
                    Text("ㅇ아ㅏ아ㅏ")
                    Text("ㅇ아ㅏ아ㅏ")
                    Text("ㅇ아ㅏ아ㅏ")
                }
                .background(Color(uiColor: .systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding()
            }
            
        }
        
    }
}



// 날짜
// 사진
// 내용
// 금액
// 분야
