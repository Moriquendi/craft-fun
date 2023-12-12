//
//  AttributesEditor.swift
//  CraftPicker
//
//  Created by Michał Śmiałko on 12/12/2023.
//

import SwiftUI
import CraftMulti

extension View {
    
    func attributesEditor(isPresented: Binding<Bool>, definition: Binding<StylingDefinition>) -> some View {
        self
#if os(iOS)
            .sheet(isPresented: isPresented) {
                NavigationStack {
                    AttributesEditor(definition: definition)
                        .navigationTitle("Workspace Logo")
                        .navigationBarTitleDisplayMode(.inline)
                    
                }
                .presentationDragIndicator(.visible)
                .presentationDetents([.fraction(0.65), .large])
            }
#else
            .popover(isPresented: isPresented) {
                AttributesEditor(definition: definition)
                    .frame(width: 290)
                    .frame(minHeight: 370)
            }
#endif
    }
    
}

struct AttributesEditor: View {
    
    @Binding var definition: StylingDefinition
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 8) {
                typeSection
                
                switch definition.stylingType {
                case .initials:
                    backgroundStyleSection
                    fontSection
                    textColorSection
                case .symbol:
                    symbolAttributes
                case .image:
                    RichImagePicker(selection: $definition.image)
                        .padding(.top, 16)
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    
    private var backgroundStyleSection: some View {
        Section {
            FancyColorPicker(color: $definition.backgroundColor)
        } header: {
            SectionHeader("Background")
        }
    }
    
    private var textColorSection: some View {
        Section {
            FancyColorPicker(color: $definition.textColor)
        } header: {
            SectionHeader("Text Color")
        }
    }
    
    private var typeSection: some View {
        VStack(alignment: .leading) {
            Picker(selection: $definition.stylingType) {
                ForEach(StylingType.allCases) {
                    Text($0.subtitle)
                }
            } label: {
                Text("")
            }
            .labelsHidden()
            .pickerStyle(.segmented)
        }
    }
    
    @ViewBuilder
    private var symbolAttributes: some View {
        backgroundStyleSection
        
        Section {
            let size: CGFloat = 55
            
            ScrollView(.horizontal) {
                HStack {
                    let symbols: [String] = [
                    "😅", "🚗", "🙉", "💰", "🏡", "💪", "⚠️",
                    ]
                    ForEach(symbols, id: \.self) { symbol in
                        let isSelected = definition.symbol == symbol
                        let shape = Circle()
                        
                        Button(action: {
                            definition.symbol = symbol
#if os(iOS)
                            UISelectionFeedbackGenerator().selectionChanged()
#endif
                        }) {
                            Text(symbol)
                                .font(.largeTitle)
                                .minimumScaleFactor(0.5)
                                .padding(8)
                                .frame(width: size, height: size)
                                .background(
                                    ZStack {
                                        Color(NativeColor.secondarySystemFill)
                                        if isSelected {
                                            Color.accentColor.opacity(0.08)
                                            shape.strokeBorder(Color.accentColor)
                                        }
                                    }
                                )
                                .clipShape(shape)
                        }
                        .buttonStyle(CraftButtonStyle())
                    }
                }
            }
            .scrollIndicators(.hidden)
        } header: {
            SectionHeader("Symbol")
        }
    }
        
    private var fontSection: some View {
        Section {
            CraftSegmentedPicker(cases: FontStyle.allCases,
                                 selection: $definition.fontStyle)
        } header: {
            SectionHeader("Font")
        }
    }
}

#Preview {
    VStack {
        AttributesEditor(definition: .constant(.mock1))
        AttributesEditor(definition: .constant(.mock2))
        AttributesEditor(definition: .constant(.mock3))
    }
}
