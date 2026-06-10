//
//  HistoryConfigurator.swift
//  V8HealthSwiftUI
//

import SwiftUI

final class HistoryConfigurator {
    @ViewBuilder
    func screen(for route: DashboardRoute) -> some View {
        switch route {
        case .activityHistory:
            ActivityHistoryView()
        case .sleepHistory:
            SleepHistoryView()
        case .heartRate:
            HeartRateView()
        case .temperature:
            TemperatureHistoryView()
        case .spo2:
            SpO2View()
        case .hrv:
            HRVHistoryView()
        case .ppi:
            PPIHistoryView()
        default:
            EmptyView()
        }
    }
}
