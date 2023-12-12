//
//  Image+Multi.swift
//  
//
//  Created by Michał Śmiałko on 19/07/2021.
//

import Foundation
import SwiftUI

#if os(macOS)
public typealias NativeImage = NSImage
#else
public typealias NativeImage = UIImage
#endif

public extension Image {
    
    init(image: NativeImage) {
        #if os(macOS)
        self.init(nsImage: image)
        #else
        self.init(uiImage: image)
        #endif
    }
    
}

#if os(macOS)
public extension NSImage {
    var cgImage: CGImage? {
        cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
    
    convenience init?(systemName: String) {
        self.init(systemSymbolName: systemName, accessibilityDescription: nil)!
    }
    
}
#endif

#if os(iOS)
public extension UIImage {
    convenience init?(contentsOf url: URL) {
        self.init(contentsOfFile: url.path)
    }
}
#endif
