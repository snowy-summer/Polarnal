//
//  AddTravelCostView.swift
//  Polarnal
//
//  Created by 최승범 on 12/18/24.
//

import SwiftUI
import SwiftData

struct AddTravelCostView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var selectedTravelViewModel: SelectedTravelViewModel
    @StateObject private var viewModel: AddTravelCostViewModel
    
    init(cost: TravelCostDB?) {
        self._viewModel = StateObject(wrappedValue: AddTravelCostViewModel(receipt: cost))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    HStack {
                        totalReceiptCard()
                            .frame(width: geometry.size.width / 3)
                            .background(Color(uiColor: .systemGray5))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        Spacer()
                        costInputView()
                    }
                    .frame(height: 400)
                    .padding()
                }
                
                HStack {
                    sectionHeader(section: .day)
                    DatePicker("", selection: $viewModel.spentDate,
                               displayedComponents: .date)
                    .labelsHidden()
                    .environment(\.locale, Locale(identifier: "ko_KR"))
                    Spacer()
                }
                .background(Color(uiColor: .systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
                
                HStack {
                    sectionHeader(section: .content)
                    TextField("간단한 내용", text: $viewModel.costDescription)
                        .padding()
                        .frame(height: 60)
                        .font(.title3)
                        .bold()
                        .background(Color(uiColor: .systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    Spacer()
                }
                .background(Color(uiColor: .systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
                
                costSection()
                    .background(Color(uiColor: .systemGray3))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding()
                
                photoSection()
            }
            .onTapGesture {
                viewModel.apply(.offDropDown)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Text("취소")
                }
                
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.apply(.generateReceipt)
                    dismiss()
                }) {
                    Text("저장")
                }
            }
        }
        .onAppear {
            viewModel.apply(.insertModelContext(modelContext, selectedTravelViewModel.selectedTravelId))
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
                                           dash: [16, 8])) // 길이의 점선과 공백을 번갈아 적용
                .frame(height: 2)
                .padding(.horizontal)
            
            HStack {
                Text(viewModel.spentCostType.symbol)
                    .font(.largeTitle)
                    .bold()
                Text(viewModel.spentCost)
                    .font(.largeTitle)
                    .bold()
            }
            .padding()
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("날짜:")
                            .font(.title3)
                            .foregroundStyle(.gray)
                        Text(viewModel.dateString)
                            .font(.title3)
                    }
                    .padding(8)
                    
                    HStack {
                        Text("종류:")
                            .font(.title3)
                            .foregroundStyle(.gray)
                        Text(viewModel.selectedCostType.title)
                            .font(.title3)
                    }
                    .padding(8)
                    
                    HStack {
                        Text("내용:")
                            .font(.title3)
                            .foregroundStyle(.gray)
                        Text(viewModel.costDescription)
                            .font(.title3)
                    }
                    .padding(8)
                }
                .padding()
                Spacer()
            }
            
            Spacer()
        }
    }
    
    private func sectionHeader(section: AddTravelCostSectionType) -> some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(uiColor: .systemGray5))
                    .frame(width: 50,
                           height: 50)
                
                Image(systemName: section.icon)
                    .resizable()
                    .frame(width: 28,
                           height: 28)
            }
            
            Text(section.text)
                .font(.title2)
                .bold()
        }
        .padding()
        
    }
    
    private func costCard(cost: Binding<String>,
                          type: CurrencyType) -> some View {
        VStack {
            HStack {
                Rectangle()
                    .frame(width: 100, height: 50)
                    .hidden()
                    .padding()
                
                TextField("ex) 1,300,499",text: cost)
                    .font(.title)
                    .bold()
            }
            
            HStack {
                Text("\(type.rawValue) (\(type.text))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.horizontal)
        }
        
    }
    
    private func costInputView() -> some View {
        ZStack {
            ZStack {
                VStack {
                    Rectangle()
                        .hidden()
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(uiColor: .systemGray6))
                        DropDownMenu(cost: $viewModel.convertedCost,
                                     selectedOptionIndex: $viewModel.selectedConvertedIndex, showDropdown: $viewModel.isShowConvertedDropdown)
                        .padding(.bottom)
                        .padding(40)
                    }
                }
                
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(uiColor: .systemGray6))
                        DropDownMenu(cost: $viewModel.spentCost,
                                     selectedOptionIndex: $viewModel.selectedSpentIndex, showDropdown: $viewModel.isShowSpentDropdown)
                        .padding(.bottom)
                        .padding(40)
                    }
                    Rectangle()
                        .hidden()
                    
                }
            }
            
            Button(action: {
                
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(uiColor: .systemGray3))
                        .frame(width: 70, height: 70)
                    Image(systemName: "repeat")
                        .resizable()
                        .frame(width: 44, height: 44)
                }
            })
            
        }
        
    }
    
    private func costSection() -> some View {
        ScrollView(.horizontal) {
            VStack {
                HStack {
                    ForEach(TravelCostType.allCases.prefix(5),
                            id: \.self) { costType in
                        costTypeCell(type: costType)
                    }
                }
                .padding(.bottom, 16)
                
                HStack {
                    ForEach(TravelCostType.allCases.suffix(from: 5),
                            id: \.self) { costType in
                        costTypeCell(type: costType)
                    }
                }
            }
            .padding(20)
        }
    }
    
    private func costTypeCell(type: TravelCostType) -> some View {
        let isSelected = type == viewModel.selectedCostType
        
        return ZStack {
            
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? .black : .clear)
                .frame(width: 260, height: 160)
            
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
            .frame(width: 250, height: 150)
            .background(type.color)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 8)
            .onTapGesture {
                viewModel.apply(.selectCostType(type))
            }
        }
        
    }
    
    private func photoSection() -> some View {
        VStack {
            HStack {
                sectionHeader(section: .photo)
                Spacer()
                Button(action: {
                    
                }, label: {
                    Image(systemName: "plus")
                        .resizable()
                        .tint(.black)
                        .frame(width: 28, height: 28)
                        .bold()
                    
                    
                })
                .padding(.trailing, 40)
            }
            ScrollView(.horizontal) {
                LazyHStack {
                    Image(.ex) // 영수증 예시이미지
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            
        }
        .background(Color(uiColor: .systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding()
        
    }
    
}

enum AddTravelCostSectionType {
    case day
    case content
    case photo
    
    var icon: String {
        switch self {
        case .day:
            return "calendar"
        case .content:
            return "note.text"
        case .photo:
            return "photo"
        }
    }
    
    var text: String {
        switch self {
        case .day:
            return "날짜"
        case .content:
            return "내용"
        case .photo:
            return "사진"
        }
    }
}

#Preview {
    AddTravelCostView(cost: nil)
}

//
//struct  DropDownMenuDemo: View {
//
//
//
//    var body: some  View {
//        VStack {
//
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//        .background(Color.yellow)
//        .onTapGesture {
//            withAnimation {
//                showDropdown =  false
//            }
//        }
//    }
//}

struct DropDownMenu: View {
    
    let options: [CurrencyType] = CurrencyType.allCases
    
    var menuWdith: CGFloat  =  100
    var buttonHeight: CGFloat  =  50
    var maxItemDisplayed: Int  =  2
    var type: CurrencyType = .KRW
    
    @Binding var cost: String
    @Binding var selectedOptionIndex: Int
    @Binding var showDropdown: Bool
    
    @State private var scrollPosition: Int?
    
    var body: some  View {
        ZStack {
            HStack {
                Text("\(type.rawValue) (\(type.text))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }
            .offset(CGSize(width: 0, height: 40.0))
            .padding(.horizontal)
            
            
            HStack {
                VStack {
                    VStack(spacing: 0) {
                        Button(action: {
                            withAnimation {
                                showDropdown.toggle()
                            }
                        }, label: {
                            HStack(spacing: nil) {
                                Text(options[selectedOptionIndex].symbol)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .rotationEffect(.degrees((showDropdown ?  -180 : 0)))
                            }
                        })
                        .padding(.horizontal, 20)
                        .frame(width: menuWdith, height: buttonHeight, alignment: .leading)
                        
                        
                        // selection menu
                        if (showDropdown) {
                            let scrollViewHeight: CGFloat  = options.count > maxItemDisplayed ? (buttonHeight*CGFloat(maxItemDisplayed)) : (buttonHeight*CGFloat(options.count))
                            ScrollView {
                                LazyVStack(spacing: 0) {
                                    ForEach(0..<options.count, id: \.self) { index in
                                        Button(action: {
                                            withAnimation {
                                                selectedOptionIndex = index
                                                showDropdown.toggle()
                                            }
                                            
                                        }, label: {
                                            HStack {
                                                Text(options[index].symbol)
                                                Spacer()
                                                if (index == selectedOptionIndex) {
                                                    Image(systemName: "checkmark.circle.fill")
                                                    
                                                }
                                            }
                                            
                                        })
                                        .padding(.horizontal, 20)
                                        .frame(width: menuWdith, height: buttonHeight, alignment: .leading)
                                        
                                    }
                                }
                                .scrollTargetLayout()
                            }
                            .scrollPosition(id: $scrollPosition)
                            .scrollDisabled(options.count <=  3)
                            .frame(height: scrollViewHeight)
                            .onAppear {
                                scrollPosition = selectedOptionIndex
                            }
                            
                        }
                        
                    }
                    .foregroundStyle(Color.white)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.black))
                    
                }
                .frame(width: menuWdith,
                       height: buttonHeight,
                       alignment: .top)
                
                TextField("ex) 1,300,499",text: $cost)
                    .font(.title)
                    .bold()
            }
        }
    }
    
    
    
}
