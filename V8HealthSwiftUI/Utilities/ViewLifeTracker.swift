//
//  ViewLifeTracker.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

private enum ViewLifeEvent: String {
    case appear
    case disappear

    var emoji: String {
        switch self {
        case .appear: return "👁️"
        case .disappear: return "🚪"
        }
    }
}

/// Debug-only lifecycle logging. No-op in Release builds.
func track(
    _ message: String,
    file: String = #fileID,
    function: String = #function,
    line: Int = #line
) {
    #if DEBUG
    let event = ViewLifeEvent(rawValue: message)
    let emoji = event?.emoji ?? "📍"
    print("\(emoji) \(message) — \(file):\(line) \(function)")
    #endif
}

/// Logs when a SwiftUI view appears and disappears (DEBUG only).
/// Deduplicates SwiftUI's occasional double onAppear/onDisappear (e.g. sheets).
struct LifeChecker: ViewModifier {
    let file: String
    let function: String
    let line: Int

    @State private var isVisible = false

    func body(content: Content) -> some View {
        #if DEBUG
        content
            .onAppear {
                guard !isVisible else { return }
                isVisible = true
                track("appear", file: file, function: function, line: line)
            }
            .onDisappear {
                guard isVisible else { return }
                isVisible = false
                track("disappear", file: file, function: function, line: line)
            }
        #else
        content
        #endif
    }
}

extension View {
    /// Attach lifecycle logging. Captures `#fileID` at the call site. DEBUG builds only.
    /// Usage: `MyView().trackLife()`
    func trackLife(
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) -> some View {
        modifier(LifeChecker(file: file, function: function, line: line))
    }
}
