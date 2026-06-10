//
//  SpO2View.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct SpO2View: View {
    @State private var viewModel = SpO2HistoryViewModel()
    private let ble = V8BLEClient.shared

    var body: some View {
        SyncLogView(
            text: viewModel.displayText,
            emptyPlaceholder: "Tap sync to load SpO2 history.",
            onSync: { viewModel.sync() },
            onDelete: { viewModel.showDeleteConfirm = true },
            docType: .spo2
        )
        .navigationTitle("Blood Oxygen")
        .requiresConnection(ble.isReady)
        .confirmationDialog("Delete all SpO2 history on the device?", isPresented: $viewModel.showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete", role: .destructive) { viewModel.deleteAll() }
            Button("Cancel", role: .cancel) {}
        }
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .trackLife()
    }
}
