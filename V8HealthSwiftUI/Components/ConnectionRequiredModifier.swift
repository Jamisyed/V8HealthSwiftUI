//
//  ConnectionRequiredModifier.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct ConnectionRequiredModifier: ViewModifier {
    let isReady: Bool

    func body(content: Content) -> some View {
        content
            .disabled(!isReady)
            .overlay {
                if !isReady {
                    ContentUnavailableView(
                        "Not Connected",
                        systemImage: "bolt.horizontal.circle",
                        description: Text("Connect a V8 device from the toolbar to use this screen.")
                    )
                }
            }
    }
}

extension View {
    func requiresConnection(_ isReady: Bool) -> some View {
        modifier(ConnectionRequiredModifier(isReady: isReady))
    }
}
