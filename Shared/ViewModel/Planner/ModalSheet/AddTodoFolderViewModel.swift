//
//  AddTodoFolderViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/12/24.
//

import SwiftUI
import Combine
import SwiftData

final class AddTodoFolderViewModel: ViewModelProtocol {
    
    @Published var todoFolderTitle: String
    @Published var todoFolderColor: Color
    private var todoFolder: TodoFolderDB?
    
    init(todoFolder: TodoFolderDB?) {
        if let todoFolder {
            self.todoFolder = todoFolder
            todoFolderTitle = todoFolder.title
            todoFolderColor = Color(red: todoFolder.color.red,
                                  green: todoFolder.color.green,
                                  blue: todoFolder.color.blue,
                                  opacity: todoFolder.color.alpha)
        } else {
            todoFolderTitle = ""
            todoFolderColor = .blue
        }
    }
    
    enum Intent {
        case selectColor(Color)
        case saveTodoFolder
        case insertModelContext(ModelContext)
    }
    
    private let dbManager = DBManager()
    var cancellables = Set<AnyCancellable>()
    
    func apply(_ intent: Intent) {
        switch intent {
        case .selectColor(let color):
            todoFolderColor = color
            
        case .saveTodoFolder:
            todoFolder == nil ? addFolder() : editFolder()
            
        case .insertModelContext(let modelContext):
            dbManager.modelContext = modelContext
        }
    }
}

extension AddTodoFolderViewModel {
    
    private func addFolder() {
        
        let newTodoFolder = TodoFolderDB(title: todoFolderTitle,
                                       color: getColorRGBA())
        dbManager.addItem(newTodoFolder)
    }
    
    private func editFolder() {
        if todoFolder != nil {
            todoFolder?.title = todoFolderTitle
            todoFolder?.color = getColorRGBA()
           
            dbManager.addItem(todoFolder!)
        }
    }
    
    private func getColorRGBA() -> CustomColor {
        
        let uiColor = UIColor(todoFolderColor)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return CustomColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}




