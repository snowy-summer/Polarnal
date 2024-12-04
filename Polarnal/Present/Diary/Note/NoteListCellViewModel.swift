//
//  NoteListCellViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import Combine

final class NoteListCellViewModel: ViewModelProtocol {
    
    enum Intent {
        
    }
    
    @Published var note: Note
    var cancellables: Set<AnyCancellable> = []
    
    init(note: Note) {
        self.note = note
    }
    
    func apply(_ intent: Intent) {
        
    }
    
}
