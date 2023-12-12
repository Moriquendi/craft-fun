//
//  Image+Representation.swift
//
//
//  Created by Michał Śmiałko on 11/12/2023.
//

import Foundation
import SwiftUI

public extension NativeImage {
    func jpegRepresentation() -> Data {
#if os(macOS)
        let cgImage = cgImage(forProposedRect: nil, context: nil, hints: nil)!
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!
        return jpegData
#else
        guard let data = self.jpegData(compressionQuality: 1) else {
            print("[🚑] JPEG TO DATA FAIL")
            return Data()
        }
        return data
#endif
    }
    
    func pngRepresentation() -> Data {
#if os(macOS)
        let cgImage = cgImage(forProposedRect: nil, context: nil, hints: nil)!
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        let pngData = bitmapRep.representation(using: NSBitmapImageRep.FileType.png, properties: [:])!
        return pngData
#else
        guard let data = self.pngData() else {
            print("[🚑] PNG TO DATA FAIL")
            return Data()
        }
        return data
#endif
    }
}
