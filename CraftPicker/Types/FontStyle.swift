//
//  FontStyle.swift
//  CraftPicker
//
//  Created by Michał Śmiałko on 12/12/2023.
//

import Foundation
import SwiftUI

enum FontStyle: CaseIterable, Identifiable {
    case system
    case serif
    case round
    
    var id: Self { self }
}

extension FontStyle: SegmentedUIPickable {
    
    var icon: AnyView {
        AnyView(_icon)
    }
    
    @ViewBuilder
    private var _icon: some View {
        switch self {
        case .system: Image(systemName: "textformat")
        case .serif: Image(systemName: "textformat")
        case .round: Image(systemName: "textformat")
        }
    }
    
    var subtitle: String {
        switch self {
        case .system: return "System"
        case .serif: return "Serif"
        case .round: return "Round"
        }
    }
}
