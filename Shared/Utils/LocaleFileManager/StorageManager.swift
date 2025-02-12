//
//  StorageManager.swift
//  Polarnal
//
//  Created by 최승범 on 2/11/25.
//

import CloudKit

#if os(macOS)
import AppKit
#endif

final class ImageStorageManager {
    static let shared = ImageStorageManager()
    private init() {}
    
    private let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let container = CKContainer(identifier: "iCloud.PolarnalContainer")
    private let database = CKContainer(identifier: "iCloud.PolarnalContainer").privateCloudDatabase
    
    /// 로컬 및 CloudKit에 이미지 저장
    func saveImageWithCloudSync(_ image: PlatformImage,
                                for noteUUID: String,
                                index: Int,
                                type: ImageCase = .note) async -> ImagePath? {
        // 로컬 저장
        guard let fileName = saveImage(image, for: noteUUID, index: index, type: type) else {
            LogManager.log("이미지 로컬 저장 실패")
            return nil
        }
        
        do {
            //CloudKit 업로드
            let recordID = try await uploadImageToCloudKit(fileName: fileName, type: type)
            LogManager.log("CloudKit 업로드 성공, Record ID: \(recordID?.recordName ?? "nil")")
            
            return ImagePath(id: fileName,
                             cloudPath: recordID?.recordName ?? "")
        } catch {
            LogManager.log("CloudKit 업로드 실패: \(error)")
            return nil
        }
    }
    
    /// 이미지 로컬에 저장
    private func saveImage(_ image: PlatformImage,
                           for noteUUID: String,
                           index: Int,
                           type: ImageCase = .note) -> String? {
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
    
    /// CloudKit 이미지 업로드
    private func uploadImageToCloudKit(fileName: String, type: ImageCase) async throws -> CKRecord.ID? {
        let fileURL = directory.appendingPathComponent(fileName)
        
        let record = CKRecord(recordType: "ImageRecord")
        let asset = CKAsset(fileURL: fileURL)
        record["image"] = asset
        
        
        return try await withCheckedThrowingContinuation { continuation in
            database.save(record) { savedRecord, error in
                if let error = error {
                    LogManager.log("CloudKit 업로드 실패: \(error)")
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: savedRecord?.recordID)
                }
            }
        }
    }
    
    /// CloudKit에서 이미지 다운로드
    func fetchImageFromCloudKit(recordName: String) async -> PlatformImage? {
        do {
            let recordID = CKRecord.ID(recordName: recordName)
            let record = try await database.record(for: recordID)
            
            if let asset = record["image"] as? CKAsset,
               let fileURL = asset.fileURL,
               let imageData = try? Data(contentsOf: fileURL),
               let image = PlatformImage(data: imageData) {
                
                return image
            }
        } catch {
            LogManager.log("CloudKit에서 이미지 불러오기 실패: \(error)")
        }
        return nil
    }
    
    /// 로컬에서 이미지 불러오기
    func loadImage(from fileName: String) -> PlatformImage? {
        let fileURL = directory.appendingPathComponent(fileName)
        
        guard let image = PlatformImage(contentsOfFile: fileURL.path) else {
            LogManager.log("이미지 로드 실패\n \(fileName)")
            return nil
        }
        
        LogManager.log("이미지 로드 성공\n \(fileName)")
        return image
    }
    
    /// 로컬 이미지 삭제
    func deleteImage(at fileName: String) {
        let fileURL = directory.appendingPathComponent(fileName)
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
    
    private func splitFileName(_ fileName: String) -> [String] {
        let cleanedFileName = fileName.replacingOccurrences(of: ".jpeg", with: "")
        return cleanedFileName.split(separator: "_").map { String($0) }
    }
}
