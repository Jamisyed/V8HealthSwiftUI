//
//  LiveDataConfigurator.swift
//  V8HealthSwiftUI
//

import SwiftUI

final class LiveDataConfigurator {
    @ViewBuilder
    func screen(for route: DashboardRoute) -> some View {
        switch route {
        case .realtimeData:
            RealtimeDataView()
        case .activityMode:
            ActivityModeView()
        case .ecg:
            ECGView()
        default:
            EmptyView()
        }
    }
}
