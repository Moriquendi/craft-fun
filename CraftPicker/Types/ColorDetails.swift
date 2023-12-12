//
//  ColorDetails.swift
//  CraftPicker
//
//  Created by Michał Śmiałko on 12/12/2023.
//

import Foundation
import SwiftUI

struct ColorDetails {
    enum ColorType: CaseIterable, Identifiable {
        case solid
        case gradient
        
        var id: Self { self }
    }
    
    var type: ColorType = .solid
    var color: CGColor
    var gradient: [CGColor]
}

extension ColorDetails {
    var textStyle: AnyShapeStyle {
        switch type {
        case .solid:
            return AnyShapeStyle( Color(cgColor: color) )
        case .gradient:
            let colors = gradient.map { Color(cgColor: $0) }
            return AnyShapeStyle( LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing) )
        }
    }    
}

extension ColorDetails.ColorType: SegmentedUIPickable {
    var icon: AnyView {
        AnyView(_icon)
    }
    
    @ViewBuilder
    private var _icon: some View {
        switch self {
        case .solid: Image(systemName: "rectangle.inset.filled")
        case .gradient:
            let shape = RoundedRectangle(cornerRadius: 2)
            let shapeOverlay = RoundedRectangle(cornerRadius: 3)
            Image(systemName: "rectangle.inset.filled")
                .hidden()
                .overlay {
                    LinearGradient(colors: [Color.mint, Color.blue], startPoint: .top, endPoint: .bottom)
                        .clipShape(shape)
                        .padding(2)
                        .overlay { shapeOverlay.strokeBorder(Color.primary, lineWidth: 1) }
                }
        }
    }
    
    var subtitle: String {
        switch self {
        case .solid: return "Color"
        case .gradient: return "Gradient"
        }
    }
}
