//
//  PPIHistoryViewModel.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

@MainActor
@Observable
final class PPIHistoryViewModel: ResponseHandlingViewModel {
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
        send(BLECommand.ppi(mode: HistorySyncMode.start, start: nil))
    }

    func deleteAll() {
        send(BLECommand.ppi(mode: HistorySyncMode.deleteAll, start: nil))
        displayText = "Delete command sent.\n"
        statusMessage = "Delete requested"
    }

    func handleResponse(_ response: ParsedDeviceResponse) {
        guard response.dataType == .ppiData else { return }

        if let items = response.dictionary["arrayPPIData"] as? [[String: Any]] {
            for item in items {
                let ppi = (item["arrayPPIData"] as? [Any])?.map { "\($0)" }.joined(separator: ", ") ?? ""
                displayText += """
                date: \(SDKHelpers.stringValue(item["date"]))
                group: \(SDKHelpers.stringValue(item["groupCount"]))
                index: \(SDKHelpers.stringValue(item["currentIndex"]))
                ppi: \(ppi)

                """
            }
        }

        if pagination.recordBatch(isEnd: response.isEnd) {
            send(BLECommand.ppi(mode: HistorySyncMode.continueSync, start: nil))
        } else if response.isEnd {
            if displayText.isEmpty { displayText = "No data\n" }
            statusMessage = "Sync complete"
        }
    }
}
