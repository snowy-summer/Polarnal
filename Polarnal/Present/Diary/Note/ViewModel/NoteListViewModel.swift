//
//  NoteListViewModel.swift
//  Polarnal
//
//  Created by 최승범 on 12/4/24.
//

import SwiftUI
import Combine

final class NoteListViewModel: ViewModelProtocol {
    
    enum Intent {
        case deleteNote(Note)
        case selectNote(Note)
    }
    
    enum NoteContentIntent {
        case addTextField
        case addImage
        case editText(of: Int, what: String)
        case saveContent([NoteContentCellData])
        case saveTitle(String)
    }
    
    //Note List 부분
    @Published var noteList: [Note] = []
    private var selectedIndex: Int?
    
    //Note Content부분
    @Published var contentTitle: String = ""
    @Published var noteContents = [NoteContentCellData]()
    
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
            }
            
        case .deleteNote(let note):
            return
        }
    }
    
    func contentApply(_ intent : NoteContentIntent) {
        switch intent {
        case .addTextField:
            noteContents.append(NoteContentCellData(id: UUID(),
                                                    type: .text))
            
        case .addImage:
            noteContents.append(NoteContentCellData(id: UUID(),
                                                    type: .image))
        case .editText(let index, let text):
            noteContents[index].textContent = text
            
        case .saveContent(let content):
            break
            
        case .saveTitle(let title):
            guard let selectedIndex else { return }
            noteList[selectedIndex].title = title
            dbManager.addItem(noteList[selectedIndex])
        }
    }
    
    func binding() {
        
        selectedIndex.publisher.sink { [weak self] index in
            guard let self = self else { return }
            contentTitle = noteList[index].title
            
            noteContents = noteList[index].contents.compactMap { content in
                self.convertToCellData(data: content)
            }
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
        
        $noteContents
            .debounce(for: .seconds(1),
                      scheduler: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self,
                      let selectedIndex else { return }
                
                noteList[selectedIndex].contents = getDBNoteContentList(dataList: data)
                LogManager.log("노트 내용 저장 시도")
                contentApply(.saveContent(data))
            }
            .store(in: &cancellables)
        
    }
    
}

extension NoteListViewModel {
    
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
