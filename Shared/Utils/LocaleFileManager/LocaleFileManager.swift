//
//  LocaleFileManager.swift
//  Polarnal
//
//  Created by 최승범 on 1/31/25.
//

#if os(iOS)
import UIKit
typealias PlatformImage = UIImage
#elseif os(macOS)
import AppKit
typealias PlatformImage = NSImage
#endif

final class LocaleFileManager {
    static let shared = LocaleFileManager()
    private init() {}
    
    private let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    /// 이미지 저장
    func saveImage(_ image: PlatformImage, for noteUUID: String, index: Int, type: ImageCase = .note) -> String? {
        let fileName = "\(type.rawValue)_\(noteUUID)_\(index).jpeg"
        let fileURL = directory.appendingPathComponent(fileName)

        guard let data = imageData(from: image) else {
            LogManager.log("이미지 압축 실패")
            return nil
        }

        do {
            try data.write(to: fileURL)
            LogManager.log("이미지 저장 성공\n \(fileURL.path)")
            return fileName
        } catch {
            LogManager.log("이미지 저장 실패\n \(error)")
            return nil
        }
    }

    /// 이미지 로드
    func loadImage(from fileName: String) -> PlatformImage? {
        let fileURL = directory.appendingPathComponent(fileName)

        #if os(iOS)
        guard let image = PlatformImage(contentsOfFile: fileURL.path) else {
            LogManager.log("이미지 로드 실패\n \(fileName)")
            return nil
        }
        #elseif os(macOS)
        guard let image = PlatformImage(contentsOf: fileURL) else {
            LogManager.log("이미지 로드 실패\n \(fileName)")
            return nil
        }
        #endif

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

    /// 플랫폼별 이미지 데이터 변환
    private func imageData(from image: PlatformImage) -> Data? {
        #if os(iOS)
        return image.jpegData(compressionQuality: 0.8)
        #elseif os(macOS)
        guard let tiffData = image.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData) else { return nil }
        return bitmap.representation(using: .jpeg, properties: [.compressionFactor: 0.8])
        #endif
    }
}

enum ImageCase: String {
    case note
    case travel
}
