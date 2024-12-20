//
//  AddTravelCostViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/18/24.
//

import SwiftUI
import Combine
import SwiftData

final class AddTravelCostViewModel: ViewModelProtocol {
    
    enum Intent {
        case insertModelContext(ModelContext, UUID?)
        case generateReceipt
        case selectCostType(TravelCostType)
        case offDropDown
    }
    
    private let dbManager = DBManager()
    private var numberFormatter = NumberFormatter()
    var travelPlanID: UUID?
    let currencyList = CurrencyType.allCases
    var receipt: TravelCostDB?
    var cancellables: Set<AnyCancellable> = []
    
    @Published var spentCost: String = ""
    @Published var spentCostType: CurrencyType = .KRW
    @Published var selectedSpentIndex =  0
    @Published var isShowSpentDropdown =  false
    
    @Published var convertedCost: String = ""
    @Published var convertedCostType: CurrencyType = .KRW
    @Published var selectedConvertedIndex =  0
    @Published var isShowConvertedDropdown =  false
    
    @Published var selectedCostType: TravelCostType = .hotel
    @Published var costDescription: String = ""
    @Published var spentDate: Date = Date()
    @Published var imageList: [UIImage] = []
    var dateString: String {
        DateManager.shared.getDateString(date: spentDate)
    }
    
    init(receipt: TravelCostDB? = nil) {
        self.receipt = receipt
        convertProperty(receipt: receipt)
        
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
    }
    
    func apply(_ intent: Intent) {
        switch intent {
        case .insertModelContext(let modelContext,
                                 let travelId):
            dbManager.modelContext = modelContext
            travelPlanID = travelId
            
        case .generateReceipt:
            
            let doubleSpentCost = stringToDoubleWithoutCommas(spentCost) ?? 0.0
            let doubleConvertedCost = stringToDoubleWithoutCommas(spentCost) ?? 0.0
            if let travelPlanID = travelPlanID {
                let receipt = TravelCostDB(spentCost: doubleSpentCost,
                                           spentCostType: spentCostType.rawValue,
                                           convertedCost: doubleConvertedCost,
                                           convertedCostType: convertedCostType.rawValue,
                                           content: costDescription,
                                           costType: selectedCostType.rawValue,
                                           date: spentDate,
                                           travelPlanID: travelPlanID)
                
                dbManager.addItem(receipt)
            }
            return
            
        case .selectCostType(let travelCostType):
            selectedCostType = travelCostType
            
        case .offDropDown:
            isShowSpentDropdown = false
            isShowConvertedDropdown = false
        }
    }
    
}

extension AddTravelCostViewModel {
    
    private func convertProperty(receipt: TravelCostDB?) {
        if let receipt {
            spentCost = String(receipt.spentCost)
            spentCostType = CurrencyType(rawValue: receipt.spentCostType) ?? .KRW
            convertedCost = String(receipt.spentCost)
            convertedCostType = CurrencyType(rawValue: receipt.convertedCostType) ?? .KRW
            selectedCostType = TravelCostType(rawValue: receipt.costType) ?? .hotel
            costDescription = receipt.content
            spentDate = receipt.date
        }
    }
    
    private func binding() {
        $spentCost
            .map { newAmount in
                // 숫자와 '.'만 허용하고, '.'은 한번만 허용
                let filtered = newAmount.filter { "0123456789.".contains($0) }
                let dotCount = filtered.filter { $0 == "." }.count
                return dotCount > 1 ? String(filtered.dropLast()) : filtered
            }
            .sink { [weak self] filteredAmount in
                // 숫자가 있으면 포맷팅하고, 없으면 그대로
                if let number = Double(filteredAmount) {
                    let formattedString = self?.numberFormatter.string(from: NSNumber(value: number)) ?? ""
                    self?.spentCost = formattedString
                } else {
                    self?.spentCost = filteredAmount
                }
            }
            .store(in: &cancellables)
    }
    
    private func doubleToStringWithCommas(_ value: Double) -> String {
        return numberFormatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
    private func stringToDoubleWithoutCommas(_ value: String) -> Double? {
        let cleanedValue = value.replacingOccurrences(of: ",", with: "")
        return Double(cleanedValue)
    }
    
}
