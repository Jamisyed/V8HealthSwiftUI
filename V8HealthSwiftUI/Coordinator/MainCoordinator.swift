//
//  MainCoordinator.swift
//  V8HealthSwiftUI
//

import SwiftUI

@MainActor
@Observable
final class MainCoordinator: Coordinator {
    let id = UUID()
    var childCoordinators: [Coordinator] = []
    var showScanner = false

    private let dashboardConfigurator = DashboardConfigurator()
    private let deviceScanConfigurator = DeviceScanConfigurator()
    private let settingsConfigurator = SettingsConfigurator()
    private let liveDataConfigurator = LiveDataConfigurator()
    private let historyConfigurator = HistoryConfigurator()
    private let otherConfigurator = OtherConfigurator()

    func start() {}

    @ViewBuilder
    func screen(for route: DashboardRoute) -> some View {
        switch route {
        case .deviceTime, .personalInfo, .stepGoal, .deviceInfo, .autoMeasurement:
            settingsConfigurator.screen(for: route)
        case .realtimeData, .activityMode, .ecg:
            liveDataConfigurator.screen(for: route)
        case .activityHistory, .sleepHistory, .heartRate, .temperature, .spo2, .hrv, .ppi:
            historyConfigurator.screen(for: route)
        case .alarms, .logExport:
            otherConfigurator.screen(for: route)
        }
    }

    func makeDashboard(showScanner: Binding<Bool>) -> some View {
        dashboardConfigurator.create(dependencies: .init(showScanner: showScanner))
    }

    func makeDeviceScanner() -> some View {
        deviceScanConfigurator.create(dependencies: .init())
    }
}

struct MainCoordinatorRootView: View {
    @Bindable var coordinator: MainCoordinator
    @Bindable private var ble = V8BLEClient.shared

    var body: some View {
        NavigationStack {
            coordinator.makeDashboard(showScanner: $coordinator.showScanner)
                .navigationTitle("V8 Health")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(ble.connection.isConnected ? "Disconnect" : "Scan") {
                            if ble.connection.isConnected {
                                ble.disconnect()
                            } else {
                                coordinator.showScanner = true
                                ble.startScan()
                            }
                        }
                    }
                }
                .navigationDestination(for: DashboardRoute.self) { route in
                    coordinator.screen(for: route)
                }
        }
        .sheet(isPresented: $coordinator.showScanner) {
            coordinator.makeDeviceScanner()
        }
        .deviceEventAlerts()
        .trackLife()
    }
}
