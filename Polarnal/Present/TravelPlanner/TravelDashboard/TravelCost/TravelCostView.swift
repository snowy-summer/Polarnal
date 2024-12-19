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
                TravelCostOverView()
                    .background(Color(uiColor: .systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding()
                
                
                TravelCostListView()
                    .background(Color(uiColor: .systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding()
            }
            
        }
        
    }
}

struct TravelCostOverView: View {
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .frame(width: 400, height: 400)
                Circle()
                    .fill(Color(uiColor: .systemGray5))
                    .frame(width: 200, height: 200)
                Text("1,523,500 ₩")
                    .font(.title)
                    .bold()
                    
                    
            }
            
            List {
                ForEach(TravelCostType.allCases, id: \.self) { type in
                    costTypeCell(type: type,
                                 percent: 24.8)
                }
            }
        }
        
    }
    
    
    private func costTypeCell(type: TravelCostType,
                              percent: Double) -> some View {
        HStack {
            Circle()
                .fill(type.color)
                .frame(width: 16, height: 16)
            
            Text(type.title)
                .padding(.leading)
            
            Text(String(format: "%.1f", percent) + "%")
            Spacer()
            Text(type.textIcon)
        }
    }
}

struct TravelCostListView: View {
    var body: some View {
        List {
            costCell()
            costCell()
            costCell()
        }
    }
    
    private func costCell() -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 44, height: 44)
                .padding()
            
            Text("인천 공항 -> 이스탄불 공항")
            Spacer()
            VStack(alignment: .trailing) {
                Text("542,900 ₩")
                    .font(.title3)
                    .bold()
                Text("24.02.12")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .padding(.top, 4)
            }
            .padding(8)
        }
    }
}

#Preview {
    TravelCostView()
}

// 날짜
// 사진
// 내용
// 금액
// 분야
