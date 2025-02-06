//
//  NoteListViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI
import Combine
import SwiftData
import EnumHelper

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

final class NoteListViewModel: ViewModelProtocol {
    
    enum Intent {
        case insertModelContext(ModelContext)
        case addNote
        case deleteNote(Note)
        case selectNote(Note)
        case selectFolder(Folder)
    }
    
    enum NoteContentIntent {
        case addTextField
        case showPhotoPicker
        case addImage
        case editText(of: Int, what: String)
        case saveContent
        case saveTitle(String)
        case deleteContent(NoteContentDataDB)
    }
    
    @Published var noteList: [Note] = []
    private var selectedIndex: Int?
    @Published private var selectedNote: Note?
    private var selectedFolder: Folder?
    
    @Published var contentTitle: String = ""
    @Published var noteContents = [NoteContentDataDB]()
    @Published var noteContentsSheetType: NoteContentSheetType?
    @Published var noteContentPhotoData = [PlatformImage]()  // 변경된 부분
    
    private let dbManager: DBManager = DBManager()
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        binding()
    }
    
    func apply(_ intent: Intent) {
        switch intent {
        case .selectNote(let note):
            if let index = noteList.firstIndex(of: note) {
                LogManager.log("노트 선택: \(note.title)")
                DispatchQueue.main.async { [weak self] in
                    self?.selectedIndex = index
                    self?.selectedNote = note
                    self?.contentTitle = note.title
                    self?.noteContents = note.contents.sorted { $0.index < $1.index }
                }
            }
            
        case .addNote:
            guard let selectedFolder = selectedFolder else {
                LogManager.log("선택된 폴더가 없습니다")
                return
            }
            let note = Note(folderID: selectedFolder.id)
            selectedFolder.noteList.append(note)
            noteList = selectedFolder.noteList
            dbManager.addItem(selectedFolder)
            self.selectedFolder = selectedFolder
            
        case .deleteNote(let note):
            if let index = noteList.firstIndex(of: note) {
                if selectedIndex == index {
                    noteClear()
                }
                noteList.remove(at: index)
                selectedFolder?.noteList = noteList
                dbManager.deleteItem(note)
            }
    
        case .selectFolder(let folder):
            clearAll()
            selectedFolder = folder
            noteList = folder.noteList
            LogManager.log("NoteListViewModel에서 폴더 선택함: \(folder.title)")
            
        case .insertModelContext(let model):
            dbManager.modelContext = model
        }
    }
    
    func contentApply(_ intent : NoteContentIntent) {
        switch intent {
        case .addTextField:
            if let selectedNote, let selectedIndex {
                let noteContent = NoteContentDataDB(type: .text,
                                                    index: noteContents.count,
                                                    noteID: selectedNote.id)
                noteContents.append(noteContent)
                noteList[selectedIndex].contents.append(noteContent)
                dbManager.addItem(noteList[selectedIndex])
            }
            
        case .showPhotoPicker:
            noteContentsSheetType = .add
            
        case .addImage:
            guard let selectedNote else {
                LogManager.log("선택된 노트가 없습니다")
                return
            }
            
            if noteContentPhotoData.isEmpty {
                LogManager.log("추가할 사진이 없습니다")
                return
            }
            
            let paths = noteContentPhotoData.compactMap {
                LocaleFileManager.shared.saveImage($0,
                                                   for: selectedNote.id.uuidString,
                                                   index: noteContents.count)
            }
            
            let imagePaths = paths.map { ImagePath(id: $0) }
            let noteContent = NoteContentDataDB(type: .image,
                                                imagePaths: imagePaths,
                                                index: noteContents.count,
                                                noteID: selectedNote.id)
            noteContents.append(noteContent)
            contentApply(.saveContent)
            
            
        case .editText(let index, let text):
            noteContents[index].textValue = text
            LogManager.log("노트 내용 저장 시도")
            contentApply(.saveContent)
            
        case .saveContent:
            guard let selectedIndex else { return }
            noteList[selectedIndex].contents = noteContents
            dbManager.addItem(noteList[selectedIndex])
            
        case .saveTitle(let title):
            guard let selectedIndex else { return }
            noteList[selectedIndex].title = title
            dbManager.addItem(noteList[selectedIndex])
            
        case .deleteContent(let noteContent):
            noteContents.remove(at: noteContent.index)
            contentApply(.saveContent)
        }
    }
    
    func binding() {
        $contentTitle
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self else { return }
                guard let selectedIndex else {
                    LogManager.log("선택된 Index가 없습니다")
                    return
                }
                
                noteList[selectedIndex].title = text
                LogManager.log("노트 제목 저장 시도")
                contentApply(.saveTitle(text))
            }
            .store(in: &cancellables)
        
        
    }
    
    private func clearAll() {
        noteList = []
        selectedIndex = nil
        selectedNote = nil
        
        noteClear()
    }
    
    private func noteClear() {
        contentTitle = ""
        noteContents = [NoteContentDataDB]()
        noteContentPhotoData = [PlatformImage]()
    }
}

@IdentifiableEnum
enum NoteContentSheetType {
    case add
    case edit
}
