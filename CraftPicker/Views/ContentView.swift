//
//  ContentView.swift
//  CraftPicker
//
//  Created by Michał Śmiałko on 11/12/2023.
//

import SwiftUI
import PhotosUI
import CraftMulti

struct ContentView: View {
    @State private var isPickerPresented = false
    @State private var selection: [PhotosPickerItem] = []
    @State private var definition: StylingDefinition = .mock2
    @State private var isAttributesSheetPresented = true
    
    var body: some View {
        HStack(spacing: 0) {
            VStack {
                #if os(macOS)
                Spacer()
                #endif
                
                Button(action: { isAttributesSheetPresented.toggle() }) {
                    WorkspaceThumbnail(definition: definition)
                }
                .buttonStyle(.plain)
                .attributesEditor(isPresented: $isAttributesSheetPresented, definition: $definition)
                
                VStack {
                    Text("WORKSPACE")
                        .foregroundStyle(.secondary)
                        .font(.callout)
                    Text("Michał Śmiałko")
                        .multilineTextAlignment(.center)
                        .font(.title)
                }
                
                Spacer()
            }
            .padding(32)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ContentView()
}
