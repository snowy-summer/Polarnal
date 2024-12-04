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
    }
    
    @Published var selectedFolder: Folder? = nil
    @Published var selectedNote: Note? = nil
    
    private let dbManager = DBManager()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        binding()
    }
    
    func apply(_ intent: Intent) {
        switch intent {
        case .selectFolder(let folder):
            selectedFolder = folder
            
        case .selectedFolderClear:
            selectedFolder = nil
            
        case .selectNote(let note):
            selectedNote = note
        }
    }
    
    func binding() {
        $selectedFolder.sink { folder in
            LogManager.log("DiaryStateViewModel에서 폴더 선택함: \(folder?.title ?? "미선택")")
        }
        .store(in: &cancellables)
    }
   
}

//MARK: - DB 관리
extension DiaryStateViewModel {
   
    // MARK: - Create
    func addFolder(name: String) {
        let newFolder = Folder(title: name)
        dbManager.addItem(newFolder)
    }
    
    func addNote(note: Note) {
        guard let folder = selectedFolder else { return }
        
        folder.noteList.append(note)
        dbManager.addItem(folder)
    }
    
    //MARK: - Delete
    func deleteFolder(_ folder: Folder) {
        if folder == selectedFolder {
            selectedFolder = nil
        }
        dbManager.deleteItem(folder)
    }
    
    func deleteNote(offsets: IndexSet) {
        guard let selectedFolder else { return }
        
        for index in offsets {
            dbManager.deleteItem(selectedFolder.noteList[index])
        }
    }
    
}
