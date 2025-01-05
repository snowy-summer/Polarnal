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
    private var eventCategory: EventCategoryDB?
    
    init(eventCategory: EventCategoryDB?) {
        if let eventCategory {
            self.eventCategory = eventCategory
            folderTitle = eventCategory.title
            folderColor = Color(red: eventCategory.color.red,
                                  green: eventCategory.color.green,
                                  blue: eventCategory.color.blue,
                                  opacity: eventCategory.color.alpha)
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
            eventCategory == nil ? addFolder() : editFolder()
            
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
        if eventCategory != nil {
            eventCategory?.title = folderTitle
            eventCategory?.color = getColorRGBA()
           
            dbManager.addItem(eventCategory!)
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




