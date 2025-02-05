//
//  PhotoPicker.swift
//  Polarnal
//
//  Created by 최승범 on 12/3/24.
//

import SwiftUI
import PhotosUI

//#if os(macOS)
struct PhotoPicker<Content: View>: View {
    @State private var selectedPhotos: [PhotosPickerItem] = []
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
    private let dismiss: () -> Void
    
    init(
        selectedImages: Binding<[PlatformImage]>,
        isPresentedError: Binding<Bool> = .constant(false),
        maxSelectedCount: Int = 1,
        matching: PHPickerFilter = .images,
        photoLibrary: PHPhotoLibrary = .shared(),
        content: @escaping () -> Content,
        dismiss: @escaping () -> Void
    ) {
        self._selectedImages = selectedImages
        self._isPresentedError = isPresentedError
        self.maxSelectedCount = maxSelectedCount
        self.matching = matching
        self.photoLibrary = photoLibrary
        self.content = content
        self.dismiss = dismiss
    }
    
    var body: some View {
        PhotosPicker(
            selection: $selectedPhotos,
            maxSelectionCount: availableSelectedCount,
            matching: matching,
            photoLibrary: photoLibrary
        ) {
            content()
        }
        .onChange(of: selectedPhotos) { oldValue, newValue in
            if !newValue.isEmpty {
                    handleSelectedPhotos(newValue)
            }
        }
    }
    
    private func handleSelectedPhotos(_ newPhotos: [PhotosPickerItem]) {
        
        Task {
            for newPhoto in newPhotos {
                if let data = try? await newPhoto.loadTransferable(type: Data.self) {
#if os(macOS)
                    guard let image = NSImage(data: data) else {
                        LogManager.log("NSImage 변환 실패")
                        return
                    }
                    
                    if !selectedImages.contains(where: { $0.tiffRepresentation == image.tiffRepresentation }) {
                        selectedImages.append(image)
                    }
#else
                    if let image = UIImage(data: data) {
                        if !selectedImages.contains(where: { $0.jpegData(compressionQuality: 0.8) == image.jpegData(compressionQuality: 0.8) }) {
                            selectedImages.append(image)
                        }
                    }
#endif
                }
            }
            
            selectedPhotos.removeAll()
            print("1")
            dismiss()
        }
        
    }
}
//#else
//struct PhotoPicker: UIViewControllerRepresentable {
//
//    @Binding var selectedImages: [PlatformImage]
//
//    func makeUIViewController(context: Context) -> PHPickerViewController {
//        var config = PHPickerConfiguration()
//        config.selectionLimit = 1
//        config.filter = .images
//
//        let picker = PHPickerViewController(configuration: config)
//        picker.delegate = context.coordinator
//
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: PHPickerViewController,
//                                context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    final class Coordinator: NSObject, PHPickerViewControllerDelegate {
//        var parent: PhotoPicker
//
//        init(_ parent: PhotoPicker) {
//            self.parent = parent
//        }
//
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            picker.dismiss(animated: true)
//
//            for result in results {
//                if result.itemProvider.canLoadObject(ofClass: PlatformImage.self) {
//                    result.itemProvider.loadObject(ofClass: PlatformImage.self) { image, error in
//                        if let uiImage = image as? PlatformImage {
//                            DispatchQueue.main.async { [weak self] in
//                                self?.parent.selectedImages.append(uiImage)
//                            }
//                        } else if let error = error {
//                            LogManager.log("이미지 불러오기 실패")
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//}
//#endif
