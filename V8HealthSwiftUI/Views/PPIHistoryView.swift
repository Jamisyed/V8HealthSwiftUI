//
//  PPIHistoryView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct PPIHistoryView: View {
    @State private var viewModel = PPIHistoryViewModel()
    private let ble = V8BLEClient.shared

    var body: some View {
        SyncLogView(
            text: viewModel.displayText,
            emptyPlaceholder: "Tap sync to load PPI history.",
            onSync: { viewModel.sync() },
            onDelete: { viewModel.showDeleteConfirm = true }
        )
        .navigationTitle("PPI")
        .requiresConnection(ble.isReady)
        .confirmationDialog("Delete all PPI history on the device?", isPresented: $viewModel.showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete", role: .destructive) { viewModel.deleteAll() }
            Button("Cancel", role: .cancel) {}
        }
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .trackLife()
    }
}
