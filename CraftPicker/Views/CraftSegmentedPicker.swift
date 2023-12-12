//
//  CraftSegmentedPicker.swift
//  CraftPicker
//
//  Created by Michał Śmiałko on 12/12/2023.
//

import SwiftUI
import CraftMulti

protocol SegmentedUIPickable: Identifiable {
    var icon: AnyView { get }
    var subtitle: String { get }
}

struct CraftSegmentedPicker<Pickable: SegmentedUIPickable>: View {
    
    let cases: [Pickable]
    @Binding var selection: Pickable
    
    private var shape: some Shape {
        RoundedRectangle(cornerRadius: 6)
    }
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(cases) { item in
                let isSelected = item.id == selection.id
                
                Button(action: {
                    selection = item
                    #if os(iOS)
                    UISelectionFeedbackGenerator().selectionChanged()
                    #endif
                }) {
                    VStack {
                        item.icon
                            .frame(height: 16)
                        Text(item.subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .foregroundStyle(Color.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(
                        ZStack {
                            Color(NativeColor.secondarySystemFill)
                            if isSelected {
                                Color.accentColor.opacity(0.05)
                            }
                        }
                    )
                    .clipShape(shape)
                    .overlay {
                        if isSelected {
                            shape.stroke(Color.accentColor, lineWidth: 2)
                        }
                    }
                }
                .buttonStyle(CraftButtonStyle())
            }
        }
        .animation(.default, value: selection.id)
    }
}

#Preview {
    CraftSegmentedPicker(cases: StylingType.allCases, selection: .constant(StylingType.image))
}
