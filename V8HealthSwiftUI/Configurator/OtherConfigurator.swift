//
//  OtherConfigurator.swift
//  V8HealthSwiftUI
//

import SwiftUI

final class OtherConfigurator {
    @ViewBuilder
    func screen(for route: DashboardRoute) -> some View {
        switch route {
        case .alarms:
            AlarmListView()
        case .logExport:
            LogExportView()
        default:
            EmptyView()
        }
    }
}
