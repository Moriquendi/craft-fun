//
//  CameraView.swift
//  CraftPicker
//
//  Created by Michał Śmiałko on 11/12/2023.
//

#if os(iOS)
import SwiftUI
import UniformTypeIdentifiers

struct CameraView: UIViewControllerRepresentable {
    
    var onDidTakePicture: (UIImage) -> Void
    var onCancel: () -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = false
        vc.cameraCaptureMode = .photo
        vc.cameraFlashMode = .auto
                
        vc.mediaTypes = [UTType.image.identifier]
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        context.coordinator.parent = self
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: CameraView
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let originalImage = info[.originalImage] as? UIImage
            let editedImage = info[.editedImage] as? UIImage
            let pickedImage = editedImage ?? originalImage
            parent.onDidTakePicture(pickedImage!)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onCancel()
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
}

#Preview {
    CameraView { _ in
        
    } onCancel: {
        
    }
}

#endif
