//
//  ActivityModeView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct ActivityModeView: View {
    @State private var viewModel = ActivityModeViewModel()
    private let ble = V8BLEClient.shared

    var body: some View {
        Form {
            Picker("Sport", selection: $viewModel.selectedSport) {
                ForEach(ActivityModeViewModel.sportTypes) { sport in
                    Text(sport.name).tag(sport)
                }
            }

            Section("Live Metrics") {
                LabeledContent("Steps", value: viewModel.metrics.steps)
                LabeledContent("Heart Rate", value: viewModel.metrics.heartRate)
                LabeledContent("Calories", value: viewModel.metrics.calories)
                LabeledContent("Active Minutes", value: viewModel.metrics.activeMinutes)
            }

            Section("Controls") {
                Button("Start") { viewModel.start() }
                Button("Pause") { viewModel.pause() }
                Button("Continue") { viewModel.resume() }
                Button("Stop", role: .destructive) { viewModel.stop() }
            }

            if !viewModel.statusMessage.isEmpty {
                Text(viewModel.statusMessage).font(.footnote).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Activity Mode")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink { FeatureDocsView(docType: .activityMode) } label: {
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
