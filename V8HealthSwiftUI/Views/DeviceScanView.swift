//
//  DeviceScanView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct DeviceScanView: View {
    @Bindable private var ble = V8BLEClient.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(ble.scannedDevices) { device in
                Button {
                    ble.connect(to: device)
                    dismiss()
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(device.name)
                                .font(.headline)
                            Text(device.rssi == 0 ? "Paired" : "RSSI \(device.rssi)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .overlay {
                if ble.scannedDevices.isEmpty {
                    ContentUnavailableView("No Devices", systemImage: "antenna.radiowaves.left.and.right", description: Text("Make sure your V8 device is nearby and powered on."))
                }
            }
            .navigationTitle("Scan Devices")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Refresh") { ble.startScan() }
                }
            }
        }
        .trackLife()
    }
}
