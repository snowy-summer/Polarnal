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
        case editText(of: Int, what: String)
        case saveContent([NoteContentCellData])
        case saveTitle(String)
    }
    
    @Published var title: String = ""
    @Published var noteContents = [NoteContentCellData]()
    var cancellables: Set<AnyCancellable> = []
    private var selectedNote: Note?
    private let dbManager = DBManager()
    
    init(stateViewModel: DiaryStateViewModel) {
        
        stateViewModel.$selectedNote
            .sink { [weak self] note in
                guard let self,
                      let note else { return }
                selectedNote = stateViewModel.selectedNote
                title = note.title
                for content in note.contents {
                    if let convertedContent = convertToCellData(data: content) {
                        noteContents.append(convertedContent)
                    }
                }
            }
            .store(in: &cancellables)
        
        $title
            .debounce(for: .seconds(1),
                      scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self else { return }
                LogManager.log("노트 제목 저장 시도")
                stateViewModel.apply(.changeNotetitle(text))
                apply(.saveTitle(text))
            }
            .store(in: &cancellables)
        
        $noteContents
            .debounce(for: .seconds(1),
                      scheduler: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self else { return }
                LogManager.log("노트 내용 저장 시도")
                stateViewModel.apply(.changeNoteContent(getDBNoteContentList(dataList: data)))
                apply(.saveContent(data))
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
            
        case .editText(let index, let text):
            noteContents[index].textContent = text
            
        case .saveContent(let dataList):
            
            let contents = getDBNoteContentList(dataList: dataList)
            
            selectedNote?.contents = contents
            if let selectedNote {
                dbManager.addItem(selectedNote)
            } else {
                LogManager.log("노트 내용을 저장에 실패했습니다")
            }
            
        case .saveTitle(let title):
            selectedNote?.title = title
            if let selectedNote {
                dbManager.addItem(selectedNote)
            } else {
                LogManager.log("노트 이름 변경으로 인한 저장에 실패했습니다")
            }
        }
        
    }
    
}

extension NoteContentViewModel {
    
    private func getDBNoteContentList(dataList: [NoteContentCellData]) -> [NoteContentData] {
        
        var contents = [NoteContentData]()
        
        for content in dataList {
            guard let convertedContent = convertToDBData(data: content) else {
                LogManager.log("DB 데이터 전환을 실패했습니다")
                return []
            }
            contents.append( convertedContent )
        }
        
        return contents
    }
    
    private func convertToCellData(data: NoteContentData) -> NoteContentCellData? {
        
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
    
    private func convertToDBData(data: NoteContentCellData) -> NoteContentData? {
        
        
        var imageDataList: [Data] = []
        
        for image in data.images {
            guard let imageData = image.pngData() else {
                LogManager.log("이미지 변환 실패")
                return nil
            }
            imageDataList.append(imageData)
        }
        
        return NoteContentData(id: data.id,
                               type: data.type,
                               imageValue: imageDataList,
                               textValue: data.textContent)
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
