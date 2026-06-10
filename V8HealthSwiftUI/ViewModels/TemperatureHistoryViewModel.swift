//
//  TemperatureHistoryViewModel.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

@MainActor
@Observable
final class TemperatureHistoryViewModel: ResponseHandlingViewModel {
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
        send(BLECommand.temperature(mode: HistorySyncMode.start, start: nil))
    }

    func deleteAll() {
        send(BLECommand.temperature(mode: HistorySyncMode.deleteAll, start: nil))
        displayText = "Delete command sent.\n"
        statusMessage = "Delete requested"
    }

    func handleResponse(_ response: ParsedDeviceResponse) {
        guard response.dataType == .temperatureData else { return }

        if let items = response.dictionary["arrayemperatureData"] as? [[String: Any]] {
            for item in items {
                displayText += "date: \(SDKHelpers.stringValue(item["date"]))\ntemp: \(SDKHelpers.stringValue(item["temperature"]))\n\n"
            }
        }

        if pagination.recordBatch(isEnd: response.isEnd) {
            send(BLECommand.temperature(mode: HistorySyncMode.continueSync, start: nil))
        } else if response.isEnd {
            if displayText.isEmpty { displayText = "No data\n" }
            statusMessage = "Sync complete"
        }
    }
}
