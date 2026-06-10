//
//  SettingsConfigurator.swift
//  V8HealthSwiftUI
//

import SwiftUI

final class SettingsConfigurator {
    @ViewBuilder
    func screen(for route: DashboardRoute) -> some View {
        switch route {
        case .deviceTime:
            DeviceTimeView()
        case .personalInfo:
            PersonalInfoView()
        case .stepGoal:
            StepGoalView()
        case .deviceInfo:
            DeviceInfoView()
        case .autoMeasurement:
            AutoMeasurementView()
        default:
            EmptyView()
        }
    }
}
