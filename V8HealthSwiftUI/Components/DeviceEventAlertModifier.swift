//
//  DeviceEventAlertModifier.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct DeviceEventAlertModifier: ViewModifier {
    @Bindable var monitor = DeviceEventMonitor.shared

    func body(content: Content) -> some View {
        content
            .alert(monitor.alertTitle ?? "Device Event", isPresented: $monitor.showAlert) {
                Button("OK", role: .cancel) {
                    monitor.dismissAlert()
                }
            } message: {
                Text(monitor.alertMessage ?? "")
            }
    }
}

extension View {
    func deviceEventAlerts() -> some View {
        modifier(DeviceEventAlertModifier())
    }
}
