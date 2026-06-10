//
//  DashboardConfigurator.swift
//  V8HealthSwiftUI
//

import SwiftUI

final class DashboardConfigurator: Configurator {
    struct Dependencies {
        @Binding var showScanner: Bool
    }

    func create(dependencies: Dependencies) -> some View {
        DashboardView(showScanner: dependencies.$showScanner)
    }
}
