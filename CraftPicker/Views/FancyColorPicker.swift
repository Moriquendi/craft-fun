//
//  FancyColorPicker.swift
//  CraftPicker
//
//  Created by Michał Śmiałko on 12/12/2023.
//

import SwiftUI
import CraftMulti

struct FancyColorPicker: View {
    
    @Binding var color: ColorDetails
    @State private var isColorPickerPresented = false
    
    private func bindingForColorAt(index: Int) -> Binding<CGColor> {
        .init {
            let gradient = color.gradient
            guard !gradient.isEmpty && index < gradient.count else {
                return NativeColor.clear.cgColor
            }
            return gradient[index]
        } set: { newColor in
            let gradient = color.gradient
            guard !gradient.isEmpty && index < gradient.count else {
                return
            }
            color.gradient[index] = newColor
        }

    }
    
    var body: some View {
        VStack(alignment: .leading) {
            CraftSegmentedPicker(cases: ColorDetails.ColorType.allCases,
                                 selection: $color.type)
            
            switch color.type {
            case .solid:
                ColorPicker(selection: $color.color, supportsOpacity: false) {
                    Text("Background Color")
                        .withMinTappableSize()
                }
            case .gradient:
                ColorPicker(selection: bindingForColorAt(index: 0),
                            supportsOpacity: false) {
                    Text("Start Color").withMinTappableSize()
                }
                ColorPicker(selection: bindingForColorAt(index: 1),
                            supportsOpacity: false) {
                    Text("End Color").withMinTappableSize()
                }
            }
        }
    }
    
    private func colorAttribute(name: String, value: Binding<ColorDetails>) -> some View {
        Button(action: {
            isColorPickerPresented.toggle()
        }) {
            HStack {
                Text(name)
                Spacer()
                Color(cgColor: value.wrappedValue.color)
                    .frame(width: 40, height: 25)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            .withMinTappableSize()
        }
        .buttonStyle(.plain)
    }
    
}

#Preview {
    FancyColorPicker(color: .constant(.init(color: CGColor(red: 0, green: 1, blue: 0, alpha: 1),
                                            gradient: CGColor.niceGradients[0])))
}
