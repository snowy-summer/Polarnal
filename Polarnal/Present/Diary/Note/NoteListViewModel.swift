//
//  NoteListViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import Combine

final class NoteListViewModel: ViewModelProtocol {
    
    enum Intent {
        case deleteNote(Note)
    }
    
    @Published var noteList: [Note] = []
    private let dbManager: DBManager = DBManager()
    var folder: PassthroughSubject<Folder, Never> = PassthroughSubject<Folder, Never>()
    var cancellables: Set<AnyCancellable> = []
    
    init(stateViewModel: DiaryStateViewModel) {
        stateViewModel.$selectedFolder
            .sink { [weak self] folder in
                self?.noteList = folder?.noteList ?? []
                LogManager.log("NoteListViewModel에서 폴더 선택함: \(folder?.title ?? "미선택")")
            }
            .store(in: &cancellables)
    }
    
    func apply(_ intent: Intent) {
        
    }
    
    func binding() {
        
    }
}
