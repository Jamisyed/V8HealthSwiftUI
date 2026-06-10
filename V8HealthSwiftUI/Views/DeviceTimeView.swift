//
//  DeviceTimeView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct DeviceTimeView: View {
    @State private var viewModel = DeviceTimeViewModel()
    private let ble = V8BLEClient.shared

    var body: some View {
        Form {
            LabeledContent("Device Time", value: viewModel.deviceTimeText)
            DatePicker("Set Time", selection: $viewModel.selectedDate)
            Button("Load from Device") { viewModel.loadFromDevice() }
            Button("Sync Phone Time") { viewModel.syncPhoneTime() }
            Button("Save Selected Time") { viewModel.saveSelectedTime() }

            if !viewModel.statusMessage.isEmpty {
                Text(viewModel.statusMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Device Time")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    FeatureDocsView(docType: .deviceTime)
                } label: {
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
