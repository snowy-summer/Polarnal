//
//  AddTravelTicketViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/23/24.
//

import SwiftUI
import Combine
import SwiftData

final class AddTravelTicketViewModel: ViewModelProtocol {
    
    enum Intent {
        case insertModelContext(ModelContext, UUID?)
        case enrollDocument
        case selectDocumentType(TravelDocumentType)
        case showAddPhotopicker
    }
    
    private let dbManager = DBManager()
    var travelPlanID: UUID?
    var document: TravelDocumentDB?
    var cancellables: Set<AnyCancellable> = []
    
    @Published var title: String = ""
    @Published var selecteddocumentType: TravelDocumentType = .flight
    
    @Published var imageList: [UIImage] = []
    
    init(document: TravelDocumentDB? = nil) {
        self.document = document
//        convertProperty(receipt: receipt)
    }
    
    func apply(_ intent: Intent) {
        switch intent {
        case .insertModelContext(let modelContext,
                                 let travelId):
            dbManager.modelContext = modelContext
            travelPlanID = travelId
            
        case .enrollDocument:
            if let travelPlanID = travelPlanID {
//                let receipt = TravelCostDB(spentCost: doubleSpentCost,
//                                           spentCostType: spentCostType.rawValue,
//                                           convertedCost: doubleConvertedCost,
//                                           convertedCostType: convertedCostType.rawValue,
//                                           content: costDescription,
//                                           costType: selectedCostType.rawValue,
//                                           date: spentDate,
//                                           travelPlanID: travelPlanID)
                
//                dbManager.addItem(receipt)
            }
            return
            
        case .selectDocumentType(let type):
            selecteddocumentType = type
            
        case .showAddPhotopicker:
            return
        }
    }
    
}

extension AddTravelTicketViewModel {
    
    private func convertProperty(receipt: TravelCostDB?) {
        if let receipt {
//            spentCost = String(receipt.spentCost)
//            spentCostType = CurrencyType(rawValue: receipt.spentCostType) ?? .KRW
//            convertedCost = String(receipt.spentCost)
//            convertedCostType = CurrencyType(rawValue: receipt.convertedCostType) ?? .KRW
//            selectedCostType = TravelCostType(rawValue: receipt.costType) ?? .hotel
//            costDescription = receipt.content
//            spentDate = receipt.date
        }
    }
    
}
