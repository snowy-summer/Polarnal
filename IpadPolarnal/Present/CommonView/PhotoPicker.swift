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

#if os(macOS)
struct PhotoPicker<Content: View>: View {
    @State private var selectedPhotos: [PhotosPickerItem]
    @Binding private var selectedImages: [PlatformImage]
    @Binding private var isPresentedError: Bool
    private let maxSelectedCount: Int
    private var disabled: Bool {
        selectedImages.count >= maxSelectedCount
    }
    private var availableSelectedCount: Int {
        maxSelectedCount - selectedImages.count
    }
    private let matching: PHPickerFilter
    private let photoLibrary: PHPhotoLibrary
    private let content: () -> Content
    
    init(
        selectedPhotos: [PhotosPickerItem] = [],
        selectedImages: Binding<[PlatformImage]>,
        isPresentedError: Binding<Bool> = .constant(false),
        maxSelectedCount: Int = 5,
        matching: PHPickerFilter = .images,
        photoLibrary: PHPhotoLibrary = .shared(),
        content: @escaping () -> Content
    ) {
        self.selectedPhotos = selectedPhotos
        self._selectedImages = selectedImages
        self._isPresentedError = isPresentedError
        self.maxSelectedCount = maxSelectedCount
        self.matching = matching
        self.photoLibrary = photoLibrary
        self.content = content
    }
    
    var body: some View {
        PhotosPicker(
            selection: $selectedPhotos,
            maxSelectionCount: availableSelectedCount,
            matching: matching,
            photoLibrary: photoLibrary
        ) {
            content()
                .disabled(disabled)
        }
        .disabled(disabled)
        .onChange(of: selectedPhotos) { _, newValue in
            handleSelectedPhotos(newValue)
        }
    }
    
    private func handleSelectedPhotos(_ newPhotos: [PhotosPickerItem]) {
        for newPhoto in newPhotos {
            newPhoto.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data, let newImage = NSImage(data: data) {
                        if !selectedImages.contains(where: { $0.pngData() == newImage.pngData() }) {
                            DispatchQueue.main.async {
                                selectedImages.append(newImage)
                            }
                        }
                    }
                case .failure:
                    isPresentedError = true
                }
            }
        }
        
        selectedPhotos.removeAll()
    }
}
#endif
