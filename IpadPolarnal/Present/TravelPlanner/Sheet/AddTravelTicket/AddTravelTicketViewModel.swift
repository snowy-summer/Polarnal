//
//  AddTravelTicketViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/23/24.
//
#if os(iOS)
import SwiftUI
import Combine
import SwiftData

final class AddTravelTicketViewModel: ViewModelProtocol {
    
    enum Intent {
        case insertModelContext(ModelContext, UUID?)
        case enrollDocument
        case selectDocumentType(TravelDocumentType)
        case showAddPhotoPicker
    }
    
    private let dbManager = DBManager()
    private var travelPlanID: UUID?
    private var document: TravelDocumentDB?
    var cancellables: Set<AnyCancellable> = []
    
    @Published var title: String = ""
    @Published var selecteddocumentType: TravelDocumentType = .flight
    @Published var imageList: [PlatformImage] = []
    @Published var isShowPhotopicker = false
    
    init(document: TravelDocumentDB? = nil) {
        self.document = document
        convertProperty(document: document)
    }
    
    func apply(_ intent: Intent) {
        switch intent {
        case .insertModelContext(let modelContext,
                                 let travelId):
            dbManager.modelContext = modelContext
            travelPlanID = travelId
            
        case .enrollDocument:
            if let travelPlanID = travelPlanID {
                let dataList = imageList.compactMap { $0.pngData() }
                let document = TravelDocumentDB(title: title,
                                                content: "",
                                                type: selecteddocumentType.rawValue,
                                                travelPlanID: travelPlanID,
                                                contentImageData: dataList)
                
                dbManager.addItem(document)
            }
            return
            
        case .selectDocumentType(let type):
            selecteddocumentType = type
            
        case .showAddPhotoPicker:
            isShowPhotopicker = true
        }
    }
    
}

extension AddTravelTicketViewModel {
    
    private func convertProperty(document: TravelDocumentDB?) {
        if let document {
            title = document.title
            imageList = document.contentImageData.compactMap { PlatformImage(data: $0) }
        }
    }
    
}
#endif
