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
            todoFolderColor = Color(hex: todoFolder.colorCode)
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
        
        if let hexCode = todoFolderColor.toHex() {
            let newTodoFolder = TodoFolderDB(title: todoFolderTitle,
                                             colorCode: hexCode)
            dbManager.addItem(newTodoFolder)
        }
        
    }
    
    private func editFolder() {
        if todoFolder != nil {
            todoFolder?.title = todoFolderTitle
            if let hexcode = todoFolderColor.toHex() {
                todoFolder?.colorCode = hexcode
            }
            
            dbManager.addItem(todoFolder!)
        }
    }
    
    private func getColorRGBA() -> CustomColor {
        
#if os(macOS)
        let uiColor = NSColor(todoFolderColor)
#else
        let uiColor = UIColor(todoFolderColor)
#endif
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return CustomColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}




