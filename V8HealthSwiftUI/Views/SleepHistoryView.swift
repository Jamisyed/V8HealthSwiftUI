//
//  SleepHistoryView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct SleepHistoryView: View {
    @State private var viewModel = SleepHistoryViewModel()
    private let ble = V8BLEClient.shared

    var body: some View {
        VStack(spacing: 0) {
            Picker("Mode", selection: $viewModel.mode) {
                ForEach(SleepHistoryMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            SyncLogView(
                text: viewModel.displayText,
                emptyPlaceholder: "Tap sync to load sleep history.",
                onSync: { viewModel.sync() },
                onDelete: { viewModel.showDeleteConfirm = true },
                docType: .sleep
            )
        }
        .navigationTitle("Sleep History")
        .requiresConnection(ble.isReady)
        .confirmationDialog("Delete all sleep history on the device?", isPresented: $viewModel.showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete", role: .destructive) { viewModel.deleteAll() }
            Button("Cancel", role: .cancel) {}
        }
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .trackLife()
    }
}
