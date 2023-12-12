//
//  SectionHeader.swift
//  CraftPicker
//
//  Created by Michał Śmiałko on 12/12/2023.
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        HStack {
            Text(title)
                .sectionHeaderStyling()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 35)
    }
}

#Preview {
    SectionHeader("Hello")
}
