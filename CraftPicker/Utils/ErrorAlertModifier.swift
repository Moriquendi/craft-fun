//
//  ErrorAlertModifier.swift
//  CraftPicker
//
//  Created by Michał Śmiałko on 11/12/2023.
//

import SwiftUI

extension NSError: Identifiable {
    public var id: String { "\(self.code)-\(self.domain)" }
}

struct ErrorAlertModifier: ViewModifier {
    @Binding var error: NSError?

    func body(content: Content) -> some View {
        content
            .background(Color.clear.alert(item: $error) { error in
                error.makeAlert {
                    self.error = nil
                }
            })
    }
}

extension Error {
    func makeAlert(dismiss: @escaping () -> Void) -> Alert {
        let title = Text(verbatim: "")
        let message = Text(localizedDescription)
        let dismissButton: Alert.Button = .cancel(Text("Cancel"), action: dismiss)
        
        return Alert(title: title,
                     message: message,
                     dismissButton: dismissButton)
    }
}

public extension View {
    func errorAlert(error: Binding<NSError?>) -> some View {
        self.modifier(ErrorAlertModifier(error: error))
    }
}

extension NSError {
    static var genericError: NSError {
        NSError(domain: "com.craft", code: -999, userInfo: [NSLocalizedDescriptionKey: "Something went wrong..."])
    }
}
