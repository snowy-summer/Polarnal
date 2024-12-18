//
//  AddTravelCostViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/18/24.
//

import Foundation
import Combine
import SwiftData

final class AddTravelCostViewModel: ViewModelProtocol {
    
    enum Intent {
        case insertModelContext(ModelContext)
        case generateReceipt
    }
    
    var receipt: TravelCostDB?
    var cancellables: Set<AnyCancellable> = []
    
    @Published var spentCost: Double = 0
    @Published var spentCostType: String = ""
    
    @Published var convertedCost: Double = 0
    @Published var convertedCostType: String = ""
    
    @Published var selectedCostType: TravelCostType = .hotel
    @Published var costDescription: String = ""
    @Published var spentDate: Date = Date()
    
    init(receipt: TravelCostDB? = nil) {
        self.receipt = receipt
        convertProperty(receipt: receipt)
    }
    
    func apply(_ intent: Intent) {
        
    }
    
}

extension AddTravelCostViewModel {
    
    private func convertProperty(receipt: TravelCostDB?) {
        if let receipt {
            spentCost = receipt.spentCost
            spentCostType = receipt.spentCostType
            convertedCost = receipt.convertedCost
            convertedCostType = receipt.convertedCostType
            selectedCostType = TravelCostType(rawValue: receipt.costType) ?? .hotel
            costDescription = receipt.content
            spentDate = receipt.date
        }
    }
    
}
