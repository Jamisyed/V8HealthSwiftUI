//
//  SpO2HistoryViewModel.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

@MainActor
@Observable
final class SpO2HistoryViewModel: ResponseHandlingViewModel {
    var displayText = ""
    var statusMessage = ""
    var showDeleteConfirm = false

    private let pagination = HistorySyncHelper()

    func onAppear() {
        subscribeToDevice()
    }

    func onDisappear() {
        unsubscribeFromDevice()
    }

    func sync() {
        displayText = "Loading…\n"
        pagination.beginSync()
        send(BLECommand.automaticSpo2(mode: HistorySyncMode.start, start: nil))
    }

    func deleteAll() {
        send(BLECommand.automaticSpo2(mode: HistorySyncMode.deleteAll, start: nil))
        displayText = "Delete command sent.\n"
        statusMessage = "Delete requested"
    }

    func handleResponse(_ response: ParsedDeviceResponse) {
        guard response.dataType == .automaticSpo2Data else { return }

        if let items = response.dictionary["arrayAutomaticSpo2Data"] as? [[String: Any]] {
            for item in items {
                displayText += "date: \(SDKHelpers.stringValue(item["date"]))\nSpO2: \(SDKHelpers.stringValue(item["automaticSpo2Data"]))\n\n"
            }
        }

        if pagination.recordBatch(isEnd: response.isEnd) {
            send(BLECommand.automaticSpo2(mode: HistorySyncMode.continueSync, start: nil))
        } else if response.isEnd {
            if displayText.isEmpty { displayText = "No data\n" }
            statusMessage = "Sync complete"
        }
    }
}
