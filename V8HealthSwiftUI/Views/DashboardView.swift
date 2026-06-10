//
//  DashboardView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct DashboardView: View {
    @Bindable private var ble = V8BLEClient.shared
    @Binding var showScanner: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                statusCard

                if !ble.lastMessage.isEmpty {
                    Text(ble.lastMessage)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                }

                ForEach(DashboardCatalog.sections) { section in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(section.title)
                            .font(.headline)
                            .padding(.horizontal)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(section.items, id: \.title) { item in
                                NavigationLink(value: item.route) {
                                    FeatureCard(icon: item.icon, title: item.title, enabled: ble.isReady)
                                }
                                .disabled(!ble.isReady)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationDestination(for: DashboardRoute.self) { route in
            destination(for: route)
        }
        .trackLife()
    }

    @ViewBuilder
    private func destination(for route: DashboardRoute) -> some View {
        switch route {
        case .deviceTime: DeviceTimeView()
        case .personalInfo: PersonalInfoView()
        case .stepGoal: StepGoalView()
        case .deviceInfo: DeviceInfoView()
        case .autoMeasurement: AutoMeasurementView()
        case .realtimeData: RealtimeDataView()
        case .activityHistory: ActivityHistoryView()
        case .sleepHistory: SleepHistoryView()
        case .heartRate: HeartRateView()
        case .temperature: TemperatureHistoryView()
        case .spo2: SpO2View()
        case .hrv: HRVHistoryView()
        case .ecg: ECGView()
        case .logExport: LogExportView()
        case .activityMode: ActivityModeView()
        case .ppi: PPIHistoryView()
        case .alarms: AlarmListView()
        }
    }

    private var statusCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(ble.isReady ? Color.green : Color.orange)
                    .frame(width: 10, height: 10)
                Text(ble.connection.status)
                    .font(.headline)
            }
            if !ble.isReady {
                Button("Connect Device") {
                    showScanner = true
                    ble.startScan()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let enabled: Bool

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
            Text(title)
                .font(.subheadline.weight(.medium))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .foregroundStyle(enabled ? Color.primary : Color.secondary)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
