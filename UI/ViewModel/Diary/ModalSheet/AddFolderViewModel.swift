//
//  AddFolderViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI
import Combine
import SwiftData

final class AddFolderViewModel: ViewModelProtocol {
    
    @Published var folderTitle: String
    @Published var newTagName: String
    @Published var folderTag: [String]
    @Published var folderColor: Color
    @Published var folderIcon: DesignOfFolderIcon
    private var folder: Folder?
    
    init(folder: Folder?) {
        if let folder {
            self.folder = folder
            folderTitle = folder.title
            newTagName = ""
            folderTag = folder.tag
            folderColor = Color(hex: folder.colorCode)
//            folderColor = Color(red: folder.color.red,
//                                green: folder.color.green,
//                                blue: folder.color.blue,
//                                opacity: folder.color.alpha)
            folderIcon = DesignOfFolderIcon(rawValue: folder.icon)
        } else {
            folderTitle = ""
            newTagName = ""
            folderTag = []
            folderColor = .blue
            folderIcon = .list
        }
    }
    
    enum Intent {
        
        case selectColor(Color)
        case selectIcon(DesignOfFolderIcon)
        case addTag
        case deleteTag(Int)
        case addFolder
        case insertModelContext(ModelContext)
        
    }
    
    private let dbManager = DBManager()
    var cancellables = Set<AnyCancellable>()
    
    func apply(_ intent: Intent) {
        switch intent {
        case .selectColor(let color):
            folderColor = color
            
        case .selectIcon(let icon):
            folderIcon = icon
            
        case .addTag:
            folderTag.append(newTagName)
            newTagName = ""
            
        case .deleteTag(let index):
            folderTag.remove(at: index)
            
        case .addFolder:
            folder == nil ? addFolder() : editFolder()
            
        case .insertModelContext(let modelContext):
            dbManager.modelContext = modelContext
        }
    }
}

extension AddFolderViewModel {
    
    private func addFolder() {
        let hexCode = folderColor.toHex()
        let newFolder = Folder(title: folderTitle,
                               colorCode: hexCode ?? "#FFFFFF",
                               icon: folderIcon.rawValue,
                               createAt: Date(),
                               tag: folderTag,
                               noteList: [])
        dbManager.addItem(newFolder)
    }
    
    private func editFolder() {
        if folder != nil {
            folder?.title = folderTitle
            folder?.colorCode = folderColor.toHex() ?? "#FFFFFF"
            folder?.icon = folderIcon.rawValue
            folder?.tag = folderTag
            dbManager.addItem(folder!)
        }
    }
}


