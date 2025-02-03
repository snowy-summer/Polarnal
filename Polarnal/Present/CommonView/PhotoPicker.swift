//
//  PhotoPicker.swift
//  Polarnal
//
//  Created by 최승범 on 12/3/24.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    
    @Binding var selectedImages: [PlatformImage]
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController,
                                context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: PlatformImage.self) {
                    result.itemProvider.loadObject(ofClass: PlatformImage.self) { image, error in
                        if let uiImage = image as? PlatformImage {
                            DispatchQueue.main.async { [weak self] in
                                self?.parent.selectedImages.append(uiImage)
                            }
                        } else if let error = error {
                            LogManager.log("이미지 불러오기 실패")
                        }
                    }
                }
            }
        }
    }
    
}
