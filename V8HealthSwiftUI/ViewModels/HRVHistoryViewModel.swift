//
//  HRVHistoryViewModel.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

@MainActor
@Observable
final class HRVHistoryViewModel: ResponseHandlingViewModel {
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
        send(BLECommand.hrv(mode: HistorySyncMode.start, start: nil))
    }

    func deleteAll() {
        send(BLECommand.hrv(mode: HistorySyncMode.deleteAll, start: nil))
        displayText = "Delete command sent.\n"
        statusMessage = "Delete requested"
    }

    func handleResponse(_ response: ParsedDeviceResponse) {
        guard response.dataType == .hrvData else { return }

        if let items = response.dictionary["arrayHrvData"] as? [[String: Any]] {
            for item in items {
                displayText += """
                date: \(SDKHelpers.stringValue(item["date"]))
                hrv: \(SDKHelpers.stringValue(item["hrv"]))
                stress: \(SDKHelpers.stringValue(item["stress"]))
                HR: \(SDKHelpers.stringValue(item["heartRate"]))
                BP: \(SDKHelpers.stringValue(item["systolicBP"]))/\(SDKHelpers.stringValue(item["diastolicBP"]))

                """
            }
        }

        if pagination.recordBatch(isEnd: response.isEnd) {
            send(BLECommand.hrv(mode: HistorySyncMode.continueSync, start: nil))
        } else if response.isEnd {
            if displayText.isEmpty { displayText = "No data\n" }
            statusMessage = "Sync complete"
        }
    }
}
