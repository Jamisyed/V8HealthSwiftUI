//
//  HRVHistoryView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct HRVHistoryView: View {
    @State private var viewModel = HRVHistoryViewModel()
    private let ble = V8BLEClient.shared

    var body: some View {
        SyncLogView(
            text: viewModel.displayText,
            emptyPlaceholder: "Tap sync to load HRV history.",
            onSync: { viewModel.sync() },
            onDelete: { viewModel.showDeleteConfirm = true },
            docType: .hrv
        )
        .navigationTitle("HRV")
        .requiresConnection(ble.isReady)
        .confirmationDialog("Delete all HRV history on the device?", isPresented: $viewModel.showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete", role: .destructive) { viewModel.deleteAll() }
            Button("Cancel", role: .cancel) {}
        }
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .trackLife()
    }
}
