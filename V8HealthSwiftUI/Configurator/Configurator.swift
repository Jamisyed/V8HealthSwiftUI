//
//  Configurator.swift
//  V8HealthSwiftUI
//

import SwiftUI

protocol Configurator {
    associatedtype Dependencies
    associatedtype Content: View

    @ViewBuilder
    func create(dependencies: Dependencies) -> Content
}
