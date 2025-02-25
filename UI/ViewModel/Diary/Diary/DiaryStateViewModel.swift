//
//  DiaryStateViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI
import Combine
import SwiftData

final class DiaryStateViewModel: ViewModelProtocol {
    
    enum Intent {
        case selectFolder(Folder)
        case selectedFolderClear
        case selectNote(Note)
        case insertModelContext(ModelContext)
    }
    
    @Published var selectedFolder: Folder? = nil
    @Published var selectedNote: Note? = nil
    
    private let dbManager = DBManager()
    var cancellables = Set<AnyCancellable>()
    
    
    func apply(_ intent: Intent) {
        switch intent {
        case .selectFolder(let folder):
            selectedNote = nil
            selectedFolder = folder
            
        case .selectedFolderClear:
            selectedFolder = nil
            
        case .selectNote(let note):
            selectedNote = note
            
        case .insertModelContext(let model):
            dbManager.modelContext = model
            
        }
    }
   
}

//MARK: - DB 관리
extension DiaryStateViewModel {
   
    // MARK: - Create
    private func addFolder(name: String) {
        let newFolder = Folder(title: name)
        dbManager.addItem(newFolder)
    }
    
    private func addNote(note: Note) {
        guard let folder = selectedFolder else { return }
        
        folder.noteList?.append(note)
        dbManager.addItem(folder)
    }
    
    //MARK: - Delete
    private func deleteFolder(_ folder: Folder) {
        if folder == selectedFolder {
            selectedFolder = nil
        }
        dbManager.deleteItem(folder)
    }
    
    private func deleteNote(offsets: IndexSet) {
        guard let selectedFolder else { return }
        
        for index in offsets {
            if let note = selectedFolder.noteList?[index] {
                dbManager.deleteItem(note)
            }
            
        }
    }
    
}
