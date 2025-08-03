//
//  MultiPhotoPicker.swift
//  BakeRoad
//
//  Created by 이현호 on 8/3/25.
//

import SwiftUI
import PhotosUI

struct MultiPhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 5 // 0 = 무제한
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: MultiPhotoPicker
        
        init(_ parent: MultiPhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            let itemProviders = results.map(\.itemProvider)
            
            for item in itemProviders {
                if item.canLoadObject(ofClass: UIImage.self) {
                    item.loadObject(ofClass: UIImage.self) { image, error in
                        if let uiImage = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.selectedImages.append(uiImage)
                            }
                        }
                    }
                }
            }
        }
    }
}
