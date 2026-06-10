//
//  TemperatureHistoryView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct TemperatureHistoryView: View {
    @State private var viewModel = TemperatureHistoryViewModel()
    private let ble = V8BLEClient.shared

    var body: some View {
        SyncLogView(
            text: viewModel.displayText,
            emptyPlaceholder: "Tap sync to load temperature history.",
            onSync: { viewModel.sync() },
            onDelete: { viewModel.showDeleteConfirm = true },
            docType: .temperature
        )
        .navigationTitle("Temperature")
        .requiresConnection(ble.isReady)
        .confirmationDialog("Delete all temperature history on the device?", isPresented: $viewModel.showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete", role: .destructive) { viewModel.deleteAll() }
            Button("Cancel", role: .cancel) {}
        }
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .trackLife()
    }
}
