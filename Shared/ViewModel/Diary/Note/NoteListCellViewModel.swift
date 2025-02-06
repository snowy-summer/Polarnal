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
    
    var subTitle: String {
        let contents = note.contents.sorted {
            $0.index < $1.index
        }
        
        let firstTextContents = contents.first { content in
            if !content.textValue.isEmpty { return true }
            else { return false }
        }
        
        return firstTextContents?.textValue ?? ""
    }
    
    var thumnailImage: PlatformImage? {
        for content in note.contents {
            if !content.imagePaths.isEmpty {
                if let path = content.imagePaths.first?.id {
                    return LocaleFileManager.shared.loadImage(from: path)
                }
            }
        }
        
        return nil
    }
    
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
        
    }
    
    func apply(_ intent: Intent) {
        
    }
}
