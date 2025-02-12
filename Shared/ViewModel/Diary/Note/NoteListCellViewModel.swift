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
        
        guard let noteContent = note.contents else {
            return ""
        }
        
        let contents = noteContent.sorted {
            $0.index < $1.index
        }
        
        let firstTextContents = contents.first { content in
            if !content.textValue.isEmpty { return true }
            else { return false }
        }
        
        return firstTextContents?.textValue ?? ""
    }
    
    var thumbnailImage: PlatformImage?  {
        
        guard let noteContent = note.contents else {
            return nil
        }
        
        for content in noteContent {
            if let imagePath = content.imagePaths?.first {
                let localImage = LocaleFileManager.shared.loadImage(from: imagePath.id)
                
                if localImage == nil {
                    Task {
                        let image = await ImageStorageManager.shared.fetchImageFromCloudKit(recordName: imagePath.cloudPath)
                        
                        return image
                    }
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
