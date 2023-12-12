//
//  Color+Common.swift
//  CraftPicker
//
//  Created by Michał Śmiałko on 12/12/2023.
//

import Foundation
import CraftMulti
import SwiftUI

extension CGColor {
    static var niceGradients: [[CGColor]] {
        [
            [NativeColor.systemMint, NativeColor.systemBlue].map { $0.cgColor }
        ]
    }
}

extension Color {
    static var reversePrimary: Color {
        Color.black
    }
    
    static var niceColors: [Color] {
        [
            .orange,
            .teal,
            .pink,
            .blue,
            .cyan,
            .mint,
        ]
    }
}
