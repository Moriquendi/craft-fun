//
//  Color+Multi.swift
//  
//
//  Created by Michał Śmiałko on 11/12/2023.
//

import Foundation
import SwiftUI
#if os(iOS)
import UIKit
#else
import AppKit
#endif


extension Color {
    
    init(color: NativeColor) {
        #if os(iOS)
        self.init(uiColor: color)
        #else
        self.init(nsColor: color)
        #endif
    }
    
}
