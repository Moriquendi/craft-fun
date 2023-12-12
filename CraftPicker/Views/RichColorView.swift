//
//  RichColorView.swift
//  CraftPicker
//
//  Created by Michał Śmiałko on 12/12/2023.
//

import SwiftUI

struct RichColorView: View {
    
    let color: ColorDetails
    
    var body: some View {
        switch color.type {
        case .solid:
            Color(cgColor: color.color)
        case .gradient:
            let colors = color.gradient.map { Color(cgColor: $0) }
            LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
        }
    }
}

#Preview {
    RichColorView(color: .init(color: CGColor(red: 0, green: 1, blue: 0, alpha: 1),
                               gradient: CGColor.niceGradients[0]))
}
