//
//  TravelPlanView.swift
//  Polarnal
//
//  Created by 최승범 on 12/26/24.
//

import SwiftUI
import SwiftData

struct TravelPlanView: View {
    var body: some View {
        GeometryReader { geometryReader in
            ScrollView(.horizontal) {
                HStack {
                    LazyVStack {
                        TravelPlanCell()
                            .frame(height: 156)
                            .background {
                                DottedLine(isVertical: true)
                                    .stroke(style: StrokeStyle(lineWidth: 4, dash: [10]))
                                    .frame(height: 160)
                                    .offset(x: 12, y: 80)
                            }
                        
                        TravelPlanCell()
                            .frame(height: 156)
                            .background(alignment: .leading) {
                                DottedLine(isVertical: true)
                                    .stroke(style: StrokeStyle(lineWidth: 4, dash: [10]))
                                    .frame(height: 160)
                                    .offset(x: 12, y: 80)
                            }
                        
                        TravelPlanCell()
                            .frame(height: 156)
                            .background(alignment: .leading) {
                                if false {
                                    DottedLine(isVertical: true)
                                        .stroke(style: StrokeStyle(lineWidth: 4, dash: [10]))
                                        .frame(height: 160)
                                        .offset(x: 12, y: 80)
                                }
                            }
                    }
                    .frame(width: geometryReader.size.width / 2)
                    
                    List {
                        TravelPlanCell()
                    }
                    .frame(width: geometryReader.size.width / 2)
                }
                .padding()
            }
        }
        
    }
}

struct TravelPlanCell: View {
    var body: some View {
            HStack(spacing: 40) {
                Circle()
                    .fill()
                    .frame(width: 24, height: 24)
                    .background(.white.shadow(.drop(color: .black.opacity(0.1), radius: 3)), in: .circle)
                
                
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(uiColor: .systemGray6))
                        .shadow(radius: 4)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.gray)
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "airplane")
                                .resizable()
                                .frame(width: 32, height: 32)
                            
                        }
                        .padding()
                        Text("인천 -> 도쿄")
                            .font(.title3)
                            .bold()
                        Spacer()
                        Text("08:30 AM")
                            .font(.caption)
                            .bold()
                            .foregroundStyle(.gray)
                            .padding()
                        
                    }
                }
            }
                .padding(16)
            
        }
    }
}

#Preview {
    TravelPlanView()
}
