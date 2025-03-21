//
//  AddTravelDestinationFolderViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 1/4/25.
//
#if os(iOS)
import SwiftUI
import Combine
import SwiftData

final class AddTravelDestinationFolderViewModel: ViewModelProtocol {
    
    enum Intent {
        case insertModelContext(ModelContext)
        case selectColor(Color)
        case saveFolder
        
    }
    
    @Published var folderTitle: String
    @Published var folderColor: Color
    private var folder: TravelDestinationFolderDB?
    private var travelPlanID: UUID?
    
    init(folder: TravelDestinationFolderDB?,
         travelID: UUID? = nil) {
        travelPlanID = travelID
        if let folder {
            self.folder = folder
            folderTitle = folder.title
            folderColor = Color(hex: folder.colorCode)
        } else {
            folderTitle = ""
            folderColor = .blue
        }
    }
    
    private let dbManager = DBManager()
    var cancellables = Set<AnyCancellable>()
    
    func apply(_ intent: Intent) {
        switch intent {
        case .insertModelContext(let model):
            dbManager.modelContext = model
            
        case .selectColor(let color):
            folderColor = color
            
        case .saveFolder:
            folder == nil ? addFolder() : editFolder()
            
        }
    }
}

extension AddTravelDestinationFolderViewModel {
    
    private func addFolder() {
        
        if let travelPlanID {
            let newFolder = TravelDestinationFolderDB(title: folderTitle,
                                                      type: "other",
                                                      travelPlanID: travelPlanID)
            dbManager.addItem(newFolder)
        }
    }
    
    private func editFolder() {
        if folder != nil {
            folder?.title = folderTitle
            if let hexCode = folderColor.toHex() {
                folder?.colorCode = hexCode
            }

            dbManager.addItem(folder!)
        }
    }
}

#endif
