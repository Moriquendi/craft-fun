//
//  StylingDefinition.swift
//  CraftPicker
//
//  Created by Michał Śmiałko on 12/12/2023.
//

import Foundation
import CraftMulti
import SwiftUI

struct StylingDefinition {
    var initials: String = ""
    var stylingType: StylingType = .image
    var fontStyle: FontStyle = .system
    
    
    // Text styling
    var backgroundColor: ColorDetails = .init(color: NativeColor.systemOrange.cgColor,
                                              gradient: CGColor.niceGradients[0])
    var textColor: ColorDetails = .init(color: Color.primary.resolve(in: .init()).cgColor,
                                        gradient: CGColor.niceGradients[0])
    
    // Symbol
    var symbol: String = "😅"
    
    // Image
    var image: NativeImage?
    
    var shape: AnyShape { AnyShape(RoundedRectangle(cornerRadius: size * 0.1)) }
    var size: CGFloat { 120 }
}

extension StylingDefinition {
    
    static var mock1: StylingDefinition {
        StylingDefinition(initials: "MŚ", stylingType: .initials)
    }
    
    static var mock2: StylingDefinition {
        StylingDefinition(initials: "MŚ", stylingType: .symbol)
    }
    
    static var mock3: StylingDefinition {
        StylingDefinition(initials: "MŚ",
                          stylingType: .image,
                          image: NativeImage(named: "mockImage"))
    }
}

extension StylingDefinition {
    var font: Font {
        switch fontStyle {
        case .system: return Font.system(size: 200)
        case .serif: return Font.system(size: 200, design: .serif)
        case .round: return Font.system(size: 200, design: .rounded)
        }
    }
}

enum StylingType: CaseIterable, Identifiable {
    case initials
    case symbol
    case image
    
    var id: Self { self }
}

extension StylingType: SegmentedUIPickable {
    var icon: AnyView {
        AnyView(_icon)
    }
    
    @ViewBuilder
    private var _icon: some View {
        switch self {
        case .initials: Image(systemName: "textformat")
        case .symbol: Image(systemName: "face.smiling")
        case .image: Image(systemName: "photo")
        }
    }
    
    var subtitle: String {
        switch self {
        case .initials: return "Initials"
        case .symbol: return "Symbol"
        case .image: return "Image"
        }
    }
}
