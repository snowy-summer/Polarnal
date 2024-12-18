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
        case selectCostType(TravelCostType)
    }
    
    private let dbManager = DBManager()
    var receipt: TravelCostDB?
    var cancellables: Set<AnyCancellable> = []
    
    @Published var spentCost: String = ""
    @Published var spentCostType: String = "₩"
    
    @Published var convertedCost: String = ""
    @Published var convertedCostType: String = "₩"
    
    @Published var selectedCostType: TravelCostType = .hotel
    @Published var costDescription: String = ""
    @Published var spentDate: Date = Date()
    var dateString: String {
        DateManager.shared.getDateString(date: spentDate)
    }
    
    init(receipt: TravelCostDB? = nil) {
        self.receipt = receipt
        convertProperty(receipt: receipt)
    }
    
    func apply(_ intent: Intent) {
        switch intent {
        case .insertModelContext(let modelContext):
            dbManager.modelContext = modelContext
            
        case .generateReceipt:
            return
            
        case .selectCostType(let travelCostType):
            selectedCostType = travelCostType
        }
    }
    
}

extension AddTravelCostViewModel {
    
    private func convertProperty(receipt: TravelCostDB?) {
        if let receipt {
            spentCost = String(receipt.spentCost)
            spentCostType = receipt.spentCostType
            convertedCost = String(receipt.spentCost)
            convertedCostType = receipt.convertedCostType
            selectedCostType = TravelCostType(rawValue: receipt.costType) ?? .hotel
            costDescription = receipt.content
            spentDate = receipt.date
        }
    }
    
}
