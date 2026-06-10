//
//  DeviceInfoView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct DeviceInfoView: View {
    @State private var viewModel = DeviceInfoViewModel()
    private let ble = V8BLEClient.shared

    var body: some View {
        List {
            LabeledContent("Battery", value: viewModel.batteryLevel)
            LabeledContent("Version", value: viewModel.deviceVersion)
            LabeledContent("MAC", value: viewModel.macAddress)

            Section("Actions") {
                Button("Refresh Battery") { viewModel.fetchBattery() }
                Button("Refresh Version") { viewModel.fetchVersion() }
                Button("Refresh MAC") { viewModel.fetchMacAddress() }
            }

            Section("Device Control") {
                Button("Factory Reset", role: .destructive) {
                    viewModel.showFactoryResetConfirm = true
                }
                Button("MCU Reset", role: .destructive) {
                    viewModel.showMCUResetConfirm = true
                }
            }

            if !viewModel.statusMessage.isEmpty {
                Text(viewModel.statusMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Device Info")
        .requiresConnection(ble.isReady)
        .confirmationDialog("Factory reset will erase all device data.", isPresented: $viewModel.showFactoryResetConfirm, titleVisibility: .visible) {
            Button("Factory Reset", role: .destructive) { viewModel.factoryReset() }
            Button("Cancel", role: .cancel) {}
        }
        .confirmationDialog("MCU reset will restart the device without erasing stored data.", isPresented: $viewModel.showMCUResetConfirm, titleVisibility: .visible) {
            Button("MCU Reset", role: .destructive) { viewModel.mcuReset() }
            Button("Cancel", role: .cancel) {}
        }
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .trackLife()
    }
}
