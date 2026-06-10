//
//  StepGoalView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct StepGoalView: View {
    @State private var viewModel = StepGoalViewModel()
    private let ble = V8BLEClient.shared

    var body: some View {
        Form {
            Stepper("Daily Goal: \(viewModel.stepGoal)", value: $viewModel.stepGoal, in: 1000...50000, step: 500)
            Button("Load from Device") { viewModel.loadFromDevice() }
            Button("Save to Device") { viewModel.saveToDevice() }

            if !viewModel.statusMessage.isEmpty {
                Text(viewModel.statusMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Step Goal")
        .requiresConnection(ble.isReady)
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .trackLife()
    }
}
