//
//  LocaleFileManager.swift
//  Polarnal
//
//  Created by 최승범 on 1/31/25.
//

import UIKit

final class LocaleFileManager {
    
    static let shared = LocaleFileManager()
    private init() {}
    private let directory = FileManager.default.urls(for: .documentDirectory,
                                                     in: .userDomainMask).first!
    
    ///이미지 저장
    func saveImage(_ image: UIImage,
                   for noteUUID: String,
                   index: Int,
                   type: ImageCase = .note) -> String? {
        let fileName = "\(type.rawValue)_\(noteUUID)_\(index).jpeg"
        let fileURL = directory.appendingPathComponent(fileName)
        
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            LogManager.log("이미지 압축 실패")
            return nil
        }
        
        do {
            try data.write(to: fileURL)
            LogManager.log("이미지 저장 성공\n \(fileURL.path)")
            return fileName
        } catch {
            LogManager.log("이미지 저장 성공\n \(error)")
            return nil
        }
    }
    
    /// 이미지 로드
    func loadImage(from fileName: String) -> UIImage? {
        let fileURL = directory.appendingPathComponent(fileName)
        
        guard let image = UIImage(contentsOfFile: fileURL.path) else {
            LogManager.log("이미지 로드 실패\n \(fileName)")
            return nil
        }
        
        LogManager.log("이미지 로드 성공\n \(fileName)")
        return image
    }
    
    /// 이미지 삭제
    func deleteImage(at filePath: String) {
        let fileURL = URL(fileURLWithPath: filePath)
        do {
            try FileManager.default.removeItem(at: fileURL)
            LogManager.log("이미지 삭제 성공")
        } catch {
            LogManager.log("이미지 삭제 실패: \(error)")
        }
    }
}

enum ImageCase: String {
    case note
    case travel
}
