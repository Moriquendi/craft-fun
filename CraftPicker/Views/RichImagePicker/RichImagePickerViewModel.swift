//
//  RichImagePickerViewModel.swift
//  CraftPicker
//
//  Created by Michał Śmiałko on 12/12/2023.
//

import Foundation
import CraftMulti
import UniformTypeIdentifiers

protocol RichImagePickerViewModel: ObservableObject {
    var recentlyUsedImages: [NativeImage] { get }
    func registerImageUsed(image: NativeImage)
}

class DefaultRichImagePickerViewModel: RichImagePickerViewModel {
    
    @Published private(set) var recentlyUsedImages: [NativeImage] = []
    
    private lazy var dirURL: URL = {
        let url = FileManager.default.temporaryDirectory.appending(path: "rich-picker-recently-used")
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: false)
        return url
    }()
    
    init() {
        Task { @MainActor in
            do {
                let images = try await Task.detached(priority: .userInitiated) { [dirURL] in
                    let filePaths = try FileManager.default.contentsOfDirectory(atPath: dirURL.path())
                    let images = filePaths.compactMap { path -> NativeImage? in
                        let url = dirURL.appending(component: path)
                        let image = NativeImage(contentsOf: url)
                        guard let image else {
                            return nil
                        }
                        return image
                    }
                    return images
                }.value
                
                self.recentlyUsedImages = images
            } catch {
                print("[Error] Failed to load recently used images from disk. \(error)")
                throw error
            }
        }
    }
    
    func registerImageUsed(image: NativeImage) {
        let fileURL = dirURL.appendingPathComponent(ISO8601DateFormatter().string(from: .now), conformingTo: UTType.jpeg)
        let data = image.jpegRepresentation()
        let ok = FileManager.default.createFile(atPath: fileURL.path(), contents: data)
        recentlyUsedImages.append(image)
        if !ok {
            print("[Error] File failed to write.")
        }
    }
    
}
