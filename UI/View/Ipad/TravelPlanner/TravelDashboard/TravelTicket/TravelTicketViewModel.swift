//
//  TravelTicketViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/23/24.
//
#if os(iOS)
import Foundation
import SwiftData
import Combine
import EnumHelper

final class TravelTicketViewModel: ViewModelProtocol {
    
    enum Intent {
        case insertModelContext(ModelContext, UUID?)
        case showAddTravelTicketView
        case showEditTravelTicketView
        case deleteTravelTicket(TravelDocumentDB)
        case fetchList
    }
    
    private let dbManager = DBManager()
    private var travelPlanID: UUID?
    var cancellables: Set<AnyCancellable> = []
    
    @Published var sheetType: TravelTicketSheetType?
    @Published var documentList: [TravelDocumentDB] = []
    
    func apply(_ intent: Intent) {
        switch intent {
        case .insertModelContext(let modelContext,
                                 let travelId):
            dbManager.modelContext = modelContext
            travelPlanID = travelId
            fetchDocumentList()
            
        case .showAddTravelTicketView:
            sheetType = .add
            
        case .showEditTravelTicketView:
            sheetType = .edit
            
        case .deleteTravelTicket(let travelTicket):
            dbManager.deleteItem(travelTicket)
            fetchDocumentList()
            
        case .fetchList:
            fetchDocumentList()
        }
    }
}

extension TravelTicketViewModel {
    
    private func fetchDocumentList() {
        if dbManager.modelContext == nil, travelPlanID == nil {
            LogManager.log("modelContext가 없습니다")
            return
        }
        
        documentList = dbManager.fetchItems(ofType: TravelDocumentDB.self).filter { cost in
            cost.travelPlanID == travelPlanID!
        }
    }

}

@IdentifiableEnum
enum TravelTicketSheetType{
    case add
    case edit
}
#endif
