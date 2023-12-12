//
//  CraftButtonStyle.swift
//  CraftPicker
//
//  Created by Michał Śmiałko on 12/12/2023.
//

import SwiftUI

struct CraftButtonStyle: ButtonStyle {
    
    @State private var isHovered = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .opacity(configuration.isPressed ? 0.89 : 1)
            .opacity(isHovered ? 0.92 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
            .animation(.easeOut(duration: 0.1), value: isHovered)
            .onHover {
                isHovered = $0
            }
    }
}

#Preview {
    Button("Hello") { }
        .buttonStyle(CraftButtonStyle())
}
