//
//  AddTravelDestinationFolderViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 1/4/25.
//

import SwiftUI
import Combine
import SwiftData

final class AddTravelDestinationFolderViewModel: ViewModelProtocol {
    
    @Published var folderTitle: String
    @Published var folderColor: Color
    private var folder: TravelDestinationFolderDB?
    
    init(folder: TravelDestinationFolderDB?) {
        if let folder {
            self.folder = folder
            folderTitle = folder.title
            folderColor = Color(red: folder.color.red,
                                  green: folder.color.green,
                                  blue: folder.color.blue,
                                  opacity: folder.color.alpha)
        } else {
            folderTitle = ""
            folderColor = .blue
        }
    }
    
    enum Intent {
        
        case selectColor(Color)
        case saveCategory
        case insertModelContext(ModelContext)
        
    }
    
    private let dbManager = DBManager()
    var cancellables = Set<AnyCancellable>()
    
    func apply(_ intent: Intent) {
        switch intent {
        case .selectColor(let color):
            folderColor = color
            
        case .saveCategory:
            folder == nil ? addFolder() : editFolder()
            
        case .insertModelContext(let modelContext):
            dbManager.modelContext = modelContext
        }
    }
}

extension AddTravelDestinationFolderViewModel {
    
    private func addFolder() {
        
        let newCategory = EventCategoryDB(title: folderTitle,
                                          color: getColorRGBA())
        dbManager.addItem(newCategory)
    }
    
    private func editFolder() {
        if folder != nil {
            folder?.title = folderTitle
            folder?.color = getColorRGBA()
           
            dbManager.addItem(folder!)
        }
    }
    
    private func getColorRGBA() -> CustomColor {
        
        let uiColor = UIColor(folderColor)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return CustomColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}




