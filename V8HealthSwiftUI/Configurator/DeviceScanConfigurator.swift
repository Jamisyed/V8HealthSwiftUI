//
//  DeviceScanConfigurator.swift
//  V8HealthSwiftUI
//

import SwiftUI

final class DeviceScanConfigurator: Configurator {
    struct Dependencies {}

    func create(dependencies: Dependencies) -> some View {
        DeviceScanView()
    }
}
