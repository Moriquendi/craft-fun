//
//  WorkspaceThumbnail.swift
//  CraftPicker
//
//  Created by Michał Śmiałko on 12/12/2023.
//

import SwiftUI
import CraftMulti

struct WorkspaceThumbnail: View {
    let definition: StylingDefinition
    
    var body: some View {
        ZStack {
            switch definition.stylingType {
            case .initials:
                initialsText
            case .symbol:
                symbolContent
            case .image:
                imageContent
            }
            
        }
        .frame(width: definition.size, height: definition.size)
        .clipShape(definition.shape)
    }
    
    private var imageContent: some View {
        ZStack {
            Color(NativeColor.black)
            
            if let image = definition.image {
                Image(image: image)
                    .resizable()
                    .scaledToFill()
            }
        }
    }
    
    private var symbolContent: some View {
        ZStack {
            RichColorView(color: definition.backgroundColor)
            
            Text(definition.symbol)
                .font(.system(size: 300))
                .minimumScaleFactor(0.1)
                .padding(10)
        }
    }
    
    private var initialsText: some View {
        ZStack {
            RichColorView(color: definition.backgroundColor)
            
            Text(definition.initials)
                .font(definition.font)
                .minimumScaleFactor(0.05)
                .fontWeight(.bold)
                .foregroundStyle(definition.textColor.textStyle)
                .padding(8)
        }
    }
}

#Preview {
    WorkspaceThumbnail(definition: .mock1)
}
