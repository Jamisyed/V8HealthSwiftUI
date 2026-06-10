//
//  AutoMeasurementView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct AutoMeasurementView: View {
    @State private var viewModel = AutoMeasurementViewModel()
    private let ble = V8BLEClient.shared

    var body: some View {
        Form {
            Toggle("Enabled", isOn: $viewModel.config.isEnabled)

            Picker("Data Type", selection: $viewModel.config.dataType) {
                Text("Heart Rate").tag(1)
                Text("SpO2").tag(2)
                Text("Temperature").tag(3)
                Text("HRV").tag(4)
            }

            Stepper("Start: \(viewModel.config.startHour):\(String(format: "%02d", viewModel.config.startMinute))", value: $viewModel.config.startHour, in: 0...23)
            Stepper("Start Minutes", value: $viewModel.config.startMinute, in: 0...59)
            Stepper("End: \(viewModel.config.endHour):\(String(format: "%02d", viewModel.config.endMinute))", value: $viewModel.config.endHour, in: 0...23)
            Stepper("End Minutes", value: $viewModel.config.endMinute, in: 0...59)

            Picker("Interval (min)", selection: $viewModel.config.intervalMinutes) {
                ForEach(viewModel.intervalOptions, id: \.self) { value in
                    Text("\(value)").tag(value)
                }
            }

            Section("Weekdays") {
                Toggle("Sunday", isOn: $viewModel.config.sunday)
                Toggle("Monday", isOn: $viewModel.config.monday)
                Toggle("Tuesday", isOn: $viewModel.config.tuesday)
                Toggle("Wednesday", isOn: $viewModel.config.wednesday)
                Toggle("Thursday", isOn: $viewModel.config.thursday)
                Toggle("Friday", isOn: $viewModel.config.friday)
                Toggle("Saturday", isOn: $viewModel.config.saturday)
            }

            Button("Load from Device") { viewModel.loadFromDevice() }
            Button("Save to Device") { viewModel.saveToDevice() }

            if !viewModel.statusMessage.isEmpty {
                Text(viewModel.statusMessage).font(.footnote).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Auto Measurement")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink { FeatureDocsView(docType: .autoMeasurement) } label: {
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
