//
//  HeartRateView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct HeartRateView: View {
    @State private var viewModel = HeartRateHistoryViewModel()
    private let ble = V8BLEClient.shared

    var body: some View {
        VStack(spacing: 0) {
            Picker("Mode", selection: $viewModel.mode) {
                ForEach(HeartRateHistoryMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            SyncLogView(
                text: viewModel.displayText,
                emptyPlaceholder: "Tap sync to load heart rate history.",
                onSync: { viewModel.sync() },
                onDelete: { viewModel.showDeleteConfirm = true },
                docType: .heartRate
            )
        }
        .navigationTitle("Heart Rate")
        .requiresConnection(ble.isReady)
        .confirmationDialog("Delete all heart rate history on the device?", isPresented: $viewModel.showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete", role: .destructive) { viewModel.deleteAll() }
            Button("Cancel", role: .cancel) {}
        }
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .trackLife()
    }
}
