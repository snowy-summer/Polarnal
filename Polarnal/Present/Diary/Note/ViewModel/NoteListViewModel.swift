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

final class NoteListViewModel: ViewModelProtocol {
    
    enum Intent {
        case insertModelContext(ModelContext)
        case deleteNote(Note)
        case selectNote(Note)
    }
    
    enum NoteContentIntent {
        case addTextField
        case showPhotoPicker
        case addImage
        case editText(of: Int, what: String)
        case saveContent
        case saveTitle(String)
        case deleteContent(Int)
    }
    
    //Note List 부분
    @Published var noteList: [Note] = []
    private var selectedIndex: Int?
    private var selectedNote: Note?
    
    //Note Content부분
    @Published var contentTitle: String = ""
    @Published var noteContents = [NoteContentDataDB]()
    @Published var noteContentsSheetType: NoteContentSheetType?
    @Published var noteContentPhotoData = [UIImage]()
    
    private let dbManager: DBManager = DBManager()
    var cancellables: Set<AnyCancellable> = []
    
    init(stateViewModel: DiaryStateViewModel) {
        stateViewModel.$selectedFolder
            .sink { [weak self] folder in
                self?.noteList = folder?.noteList ?? []
                LogManager.log("NoteListViewModel에서 폴더 선택함: \(folder?.title ?? "미선택")")
            }
            .store(in: &cancellables)
        
        binding()
    }
    
    func apply(_ intent: Intent) {
        switch intent {
        case .selectNote(let note):
            if let index = noteList.firstIndex(of: note) {
                selectedIndex = index
                selectedNote = note
                contentTitle = note.title
                noteContents = note.contents.sorted {
                    $0.index < $1.index
                }
            }
            
        case .deleteNote(let note):
            dbManager.deleteItem(note)
            
        case .insertModelContext(let model):
            dbManager.modelContext = model
        }
    }
    
    func contentApply(_ intent : NoteContentIntent) {
        switch intent {
        case .addTextField:
            if let selectedNote,
               let selectedIndex {
                let noteContent = NoteContentDataDB(type: NoteContentType.text,
                                                    index: noteContents.count,
                                                    noteID: selectedNote.id)
                noteContents.append(noteContent)
                noteList[selectedIndex].contents.append(noteContent)
                dbManager.addItem(noteList[selectedIndex])
            }
            
        case .showPhotoPicker:
            noteContentsSheetType = .add
            
        case .addImage:
            if let selectedNote {
                let paths = noteContentPhotoData.compactMap {
                    LocaleFileManager.shared.saveImage($0,
                                                       for: selectedNote.id.uuidString,
                                                       index: noteContents.count)
                }
                
                let imagePaths = paths.map { ImagePath(id: $0)}

                let noteContent = NoteContentDataDB(type: .image,
                                                    imagePaths: imagePaths,
                                                    index: noteContents.count,
                                                    noteID: selectedNote.id)
                noteContents.append(noteContent)
                contentApply(.saveContent)
            }
            
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
            
        case .deleteContent(let index):
            noteContents.remove(at: index)
        }
    }
    
    func binding() {
        
        selectedIndex.publisher.sink { [weak self] index in
            guard let self = self else { return }
            contentTitle = noteList[index].title
            
            noteContents = noteList[index].contents
        }
        .store(in: &cancellables)
        
        $contentTitle
            .debounce(for: .seconds(1),
                      scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self,
                      let selectedIndex else { return }
                
                noteList[selectedIndex].title = text
                LogManager.log("노트 제목 저장 시도")
                contentApply(.saveTitle(text))
            }
            .store(in: &cancellables)
        
    }
    
}

@IdentifiableEnum
enum NoteContentSheetType {
    case add
    case edit
}
