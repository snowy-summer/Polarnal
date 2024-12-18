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

struct AddTravelCostView: View {
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    totalReceiptCard()
                        .background(Color(uiColor: .systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    VStack {
                        HStack {
                            costCard()
                                .padding()
                                .background(Color(uiColor: .systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding()
                            Circle()
                                .frame(width: 72, height: 72)
                            costCard()
                                .padding()
                                .background(Color(uiColor: .systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding()
                        }
                        Button(action: {
                            
                        }, label: {
                            Text("발행")
                                .padding()
                                .background(Color(uiColor: .systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding()
                        })
                        
                    }
                }
                .frame(height: 300)
                .padding()
                
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 80)
                    .padding()
                
                costSection()
                .background(Color(uiColor: .systemGray3))
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding()
                
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 600)
                    .padding()
            }
        }
    }
    
    private func totalReceiptCard() -> some View {
        VStack {
            
            Text("영수증")
                .font(.largeTitle)
                .bold()
                .padding()
            DottedLine()
                .stroke(style: StrokeStyle(lineWidth: 4,
                                           dash: [20, 20])) // 길이의 점선과 공백을 번갈아 적용
                .frame(height: 2)
                .padding(.horizontal)
            HStack {
                Text("₩")
                    .font(.largeTitle)
                    .bold()
                Text("1,842,214")
                    .font(.largeTitle)
                    .bold()
            }
            .padding()
            
            VStack(alignment: .leading) {
                HStack {
                    Text("날짜:")
                        .foregroundStyle(.gray)
                    Text("24.03.12")
                }
                HStack {
                    Text("카테고리:")
                        .foregroundStyle(.gray)
                    Text("비행기")
                }
                HStack {
                    Text("내용:")
                        .foregroundStyle(.gray)
                    Text("인천공항 -> 터키 이스탄불 공항")
                }
            }
            
            Spacer()
        }
    }
    
    struct DottedLine: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: rect.minX, y: rect.minY)) // 시작점
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // 끝점
            return path
        }
    }
    
    private func costCard() -> some View {
        HStack {
            
            
            Button(action: {
                
            }, label: {
                HStack {
                    Text("₩")
                        .font(.title)
                        .bold()
                    Image(systemName: "chevron.down")
                }
            })
            .padding()
            .background(Color(uiColor: .systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Text("1,842,214")
                .font(.title)
                .bold()
        }
        
    }
    
    private func costSection() -> some View {
        ScrollView(.horizontal) {
            VStack {
                
                HStack {
                    ForEach(TravelCostType.allCases.prefix(5),
                            id: \.self) { costType in
                        costTypeCell(type: costType)
                            .frame(width: 250, height: 150)
                            .background(Color(uiColor: .systemGray5))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal, 8)
                    }
                }
                .padding(.bottom, 16)
                
                HStack {
                    ForEach(TravelCostType.allCases.suffix(from: 5),
                            id: \.self) { costType in
                        costTypeCell(type: costType)
                            .frame(width: 250, height: 150)
                            .background(Color(uiColor: .systemGray5))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal, 8)
                    }
                }
            }
            .padding(20)
        }
    }
    
    private func costTypeCell(type: TravelCostType) -> some View {
        VStack {
            HStack {
                Image(systemName: type.icon)
                    .resizable()
                    .frame(width: 50, height: 50)
                Spacer()
            }
            .padding()
            
            HStack{
                Spacer()
                
                Text(type.title)
                    .font(.title)
                    .bold()
            }
            .padding()
        }
    }
}


#Preview {
    AddTravelCostView()
}

// 날짜
// 사진
// 내용
// 금액
// 분야
