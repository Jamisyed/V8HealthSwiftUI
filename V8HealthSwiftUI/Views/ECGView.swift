//
//  ECGView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct ECGView: View {
    @State private var viewModel = ECGViewModel()
    private let ble = V8BLEClient.shared

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Button("Start") { viewModel.startMeasurement() }
                        .buttonStyle(.borderedProminent)
                        .disabled(viewModel.isMeasuring)
                    Button("Stop") { viewModel.stopMeasurement() }
                        .buttonStyle(.bordered)
                        .disabled(!viewModel.isMeasuring)
                }

                HStack {
                    LabeledContent("Packet Loss", value: viewModel.packetLoss)
                    LabeledContent("Loss (5s)", value: viewModel.packetLoss5s)
                }
                HStack {
                    LabeledContent("Min", value: viewModel.minValue)
                    LabeledContent("Max", value: viewModel.maxValue)
                }

                ECGWaveformView(samples: viewModel.ecgSamples)
                    .frame(height: 180)

                if !viewModel.statusMessage.isEmpty {
                    Text(viewModel.statusMessage)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle("ECG")
        .requiresConnection(ble.isReady)
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .trackLife()
    }
}
