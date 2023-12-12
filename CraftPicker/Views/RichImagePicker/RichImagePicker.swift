//
//  RichImagePicker.swift
//  CraftPicker
//
//  Created by Michał Śmiałko on 11/12/2023.
//

import SwiftUI
import Photos
import CraftMulti
import PhotosUI

extension NativeImage: @unchecked Sendable { }

struct RichImagePicker<VM: RichImagePickerViewModel>: View {
    
    @Binding var selection: NativeImage?
    
    @StateObject private var vm: VM
    @State private var isImporting = false
    @State private var isPhotoLibraryPresented = false
    @State private var isCameraPresented = false
    @State private var pickedPhotoItems: [PhotosPickerItem] = []
    @State private var isSourcePickerPresented = false
    @State private var isFilePickerPresented = false
    @State private var error: NSError?
    
    init(selection: Binding<NativeImage?>) where VM == DefaultRichImagePickerViewModel {
        let injected = DefaultRichImagePickerViewModel() // TODO: Should be injectable.
        _vm = .init(wrappedValue: injected)
        _selection = selection
    }
    
    var body: some View {
        VStack {
            ZStack {
                if selection == nil {
                    importArea
                } else {
                    imagePreview
                }
            }
            .aspectRatio(1, contentMode: .fit)
            
            if !vm.recentlyUsedImages.isEmpty {
                Divider()
                SectionHeader("Recently Used")
                recentlyUsedPicker
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
        #if os(iOS)
        .fullScreenCover(isPresented: $isCameraPresented) {
            CameraView { image in
                didPick(images: [image])
                isCameraPresented.toggle()
            } onCancel: {
                isCameraPresented.toggle()
            }
            .ignoresSafeArea()
        }
        #endif
        .photosPicker(isPresented: $isPhotoLibraryPresented,
                      selection: $pickedPhotoItems,
                      maxSelectionCount: 1,
                      selectionBehavior: .ordered,
                      matching: .images,
                      preferredItemEncoding: .automatic)
        .errorAlert(error: $error)
        .fileImporter(isPresented: $isFilePickerPresented, allowedContentTypes: [.image],
                      allowsMultipleSelection: false, onCompletion: { result in
            switch result {
            case .success(let urls):
                guard let url = urls.first else { return }
                guard url.startAccessingSecurityScopedResource() else { return }
                defer { url.stopAccessingSecurityScopedResource() }
                
                guard let image = NativeImage(contentsOf: url) else { return }
                didPick(images: [image])
            case .failure: break
            }
        })
        .confirmationDialog("", isPresented: $isSourcePickerPresented) {
#if os(iOS)
            Button("Take a Photo") { isCameraPresented.toggle() }
#else
            Button("Pick a File") { isFilePickerPresented.toggle() }
#endif
            Button("Choose from Photos Library") { isPhotoLibraryPresented.toggle() }
        }
        .onChange(of: pickedPhotoItems) { _, photoItems in
            guard !photoItems.isEmpty else { return }

            Task { @MainActor in
                isImporting = true
                defer { isImporting = false }
                
                do {
                    let images = try await withThrowingTaskGroup(of: (PhotosPickerItem, NativeImage).self, returning: [NativeImage].self) { group in
                        for photoItem in photoItems {
                            group.addTask {
                                let data = try await photoItem.loadTransferable(type: Data.self)
                                guard let data else {
                                    throw NSError.genericError
                                }
                                guard let theImage = NativeImage(data: data) else {
                                    throw NSError.genericError
                                }
                                return (photoItem, theImage)
                            }
                        }
                        
                        var all: [PhotosPickerItem : NativeImage] = [:]
                        for try await result in group {
                            all[result.0] = result.1
                        }
                        
                        let sorted = photoItems.compactMap { all[$0] }
                        
                        return sorted
                    }
                    
                    didPick(images: images)
                } catch {
                    print(error)
                    self.error = error as NSError
                }
            }
            
            // Clear selection
            self.pickedPhotoItems = []
        }
    }
    
    private func didPick(images: [NativeImage]) {
        guard let image = images.first else { return }
        // TODO: Would be good to resize the images so that
        // we don't keep original huge resolution.
        self.selection = image
        vm.registerImageUsed(image: image)
    }
    
    @ViewBuilder
    private var recentlyUsedPicker: some View {
        let size: CGFloat = 60
        LazyVGrid(columns: [.init(.adaptive(minimum: size, maximum: size), spacing: 8)],
                  alignment: .leading) {
            ForEach(vm.recentlyUsedImages.indices, id: \.self) { idx in
                let image = vm.recentlyUsedImages[idx]
                
                Button(action: {
                    self.selection = image
                }) {
                    Image(image: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size, height: size)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                .buttonStyle(.borderless)
            }
        }
    }
    
    @ViewBuilder
    private var imagePreview: some View {
        if let image = selection {
            Image(image: image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: .infinity)
                .hidden()
                .overlay {
                    Image(image: image)
                        .resizable()
                        .scaledToFill()
                }
                .cornerRadius(8)
                .overlay(alignment: .topTrailing) {
                    Button {
                        self.selection = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(8)
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(.plain)
                }
        }
    }
    
    private var importArea: some View {
        Button {
            guard !isImporting else { return }
            isSourcePickerPresented.toggle()
        } label: {
            ZStack {
                Color(NativeColor.secondarySystemFill)
                    .cornerRadius(16)
                
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.accentColor,
                            style: .init(lineWidth: 3, dash: [10, 10]))
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1, contentMode: .fit)
                
                if isImporting {
                    ProgressView().progressViewStyle(.circular)
                } else {
                    HStack(spacing: 16) {
                        Image(systemName: "camera")
                        Divider()
                            .frame(height: 30)
                        Image(systemName: "photo.on.rectangle.angled")
                    }
                    .font(.title)
                }
            }
        }
        .buttonStyle(CraftButtonStyle())
    }
}

#Preview {
    RichImagePicker(selection: .constant(nil))
}
