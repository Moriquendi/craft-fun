//
//  View+Utils.swift
//  CraftPicker
//
//  Created by Michał Śmiałko on 12/12/2023.
//

import SwiftUI

extension View {
    func withMinTappableSize() -> some View {
        #if os(macOS)
        self.frame(minHeight: 25)
        #else
        self.frame(minHeight: 44)
        #endif
    }
}
