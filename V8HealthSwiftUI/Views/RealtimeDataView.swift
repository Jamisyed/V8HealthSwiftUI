//
//  RealtimeDataView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct RealtimeDataView: View {
    @State private var viewModel = RealtimeDataViewModel()
    private let ble = V8BLEClient.shared

    var body: some View {
        Form {
            Toggle("Real-time Steps", isOn: Binding(
                get: { viewModel.realtimeStepsEnabled },
                set: { viewModel.setRealtimeSteps($0) }
            ))
            Toggle("Manual HR (30s)", isOn: Binding(
                get: { viewModel.manualHREnabled },
                set: { viewModel.setManualHR($0) }
            ))
            Toggle("Manual SpO2 (30s)", isOn: Binding(
                get: { viewModel.manualSpO2Enabled },
                set: { viewModel.setManualSpO2($0) }
            ))

            Section("Live Metrics") {
                LabeledContent("Steps", value: viewModel.metrics.steps)
                LabeledContent("Calories", value: viewModel.metrics.calories)
                LabeledContent("Distance", value: viewModel.metrics.distance)
                LabeledContent("Exercise Time", value: viewModel.metrics.exerciseTime)
                LabeledContent("Strength Time", value: viewModel.metrics.strengthTime)
                LabeledContent("Heart Rate", value: viewModel.metrics.heartRate)
                LabeledContent("SpO2", value: viewModel.metrics.spo2)
            }

            if !viewModel.statusMessage.isEmpty {
                Text(viewModel.statusMessage).font(.footnote).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Real-time Data")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink { FeatureDocsView(docType: .realtimeStep) } label: {
                    Image(systemName: "questionmark.circle")
                }
            }
        }
        .requiresConnection(ble.isReady)
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .trackLife()
    }
}
