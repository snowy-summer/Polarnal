//
//  NoteListCellViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI
import Combine

final class NoteListCellViewModel: ViewModelProtocol {
    
    enum Intent {
        
    }
    
    @Published var note: Note
    @Published var thumnailImage: PlatformImage?
    let monthString: String
    let dayString: String
    private let dateManager = DateManager.shared
    var cancellables: Set<AnyCancellable> = []
    
    init(note: Note) {
        self.note = note
        monthString = dateManager.getDateString(format: "MM",
                                               date: note.createAt)
        dayString = dateManager.getDateString(format: "dd",
                                               date: note.createAt)
        getThumbnail()
    }
    
    func apply(_ intent: Intent) {
        
    }
    
    
    private func getThumbnail() {
        for content in note.contents {
            if !content.imagePaths.isEmpty {
                if let path = content.imagePaths.first?.id {
                    thumnailImage = LocaleFileManager.shared.loadImage(from: path)
                    return
                }
            }
        }
    }
}
