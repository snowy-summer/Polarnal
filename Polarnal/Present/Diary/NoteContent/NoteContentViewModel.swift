//
//  NoteContentViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/5/24.
//

import SwiftUI
import Combine

final class NoteContentViewModel: ViewModelProtocol {
    
    enum Intent {
        case addTextField
        case addImage
    }
    
    @Published var title: String = ""
    @Published var noteContents = [NoteContentCellData]()
    var cancellables: Set<AnyCancellable> = []
    
    init(stateViewModel: DiaryStateViewModel) {
        stateViewModel.$selectedNote
            .sink { [weak self] note in
                guard let self,
                      let note else { return }
                title = note.title
                for content in note.contents {
                    if let convertedContent = convertNoteContentData(data: content) {
                        noteContents.append(convertedContent)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func apply(_ intent: Intent) {
        
        switch intent {
        case .addTextField:
            noteContents.append(NoteContentCellData(id: UUID(),
                                                    type: .text))
            
        case .addImage:
            noteContents.append(NoteContentCellData(id: UUID(),
                                                    type: .image))
        }
    }
    
}

extension NoteContentViewModel {
    
    private func convertNoteContentData(data: NoteContentData) -> NoteContentCellData? {
        
        guard let type = NoteContentType(rawValue: data.type) else {
            LogManager.log("잘못된 타입이 존재합니다")
            return nil
        }
        
        var imageValue: [UIImage] = []
        
        for imageData in data.imageValue {
            guard let image = UIImage(data: imageData) else {
                LogManager.log("이미지 변환 실패")
                return nil
            }
            imageValue.append(image)
        }
        
        return NoteContentCellData(id: data.id,
                                   type: type,
                                   images: imageValue,
                                   textContent: data.textValue)
    }
}

struct NoteContentCellData: Identifiable {
    let id: UUID
    let type: NoteContentType
    var images: [UIImage]
    var textContent: String
    
    init(id: UUID,
         type: NoteContentType,
         images: [UIImage] = [],
         textContent: String = "") {
        self.id = id
        self.type = type
        self.images = images
        self.textContent = textContent
    }
    
}
