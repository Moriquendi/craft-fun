//
//  Text+Styling.swift
//  CraftPicker
//
//  Created by Michał Śmiałko on 12/12/2023.
//

import SwiftUI

extension Text {
    func sectionHeaderStyling() -> some View {
        self
            .textCase(.uppercase)
            .font(.footnote)
            .fontWeight(.medium)
            .foregroundStyle(.secondary)
            .foregroundStyle(.secondary)
    }
}
