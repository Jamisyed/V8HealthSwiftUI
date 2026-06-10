//
//  HeartRateHistoryViewModel.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

enum HeartRateHistoryMode: String, CaseIterable, Identifiable {
    case continuous = "Continuous"
    case single = "Single"

    var id: String { rawValue }
}

@MainActor
@Observable
final class HeartRateHistoryViewModel: ResponseHandlingViewModel {
    var mode: HeartRateHistoryMode = .continuous
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
        switch mode {
        case .continuous:
            send(BLECommand.continuousHR(mode: HistorySyncMode.start, start: nil))
        case .single:
            send(BLECommand.singleHR(mode: HistorySyncMode.start, start: nil))
        }
    }

    func deleteAll() {
        switch mode {
        case .continuous:
            send(BLECommand.continuousHR(mode: HistorySyncMode.deleteAll, start: nil))
        case .single:
            send(BLECommand.singleHR(mode: HistorySyncMode.deleteAll, start: nil))
        }
        displayText = "Delete command sent.\n"
        statusMessage = "Delete requested"
    }

    func handleResponse(_ response: ParsedDeviceResponse) {
        switch response.dataType {
        case .dynamicHR:
            appendContinuous(response)
        case .staticHR:
            appendSingle(response)
        default:
            break
        }
    }

    private func appendContinuous(_ response: ParsedDeviceResponse) {
        if let items = response.dictionary["arrayContinuousHR"] as? [[String: Any]] {
            for item in items {
                let date = SDKHelpers.stringValue(item["date"])
                let hrs = (item["arrayHR"] as? [Any])?.map { "\($0)" }.joined(separator: ", ") ?? ""
                displayText += "date: \(date)\nHR: \(hrs)\n\n"
            }
        }
        handlePagination(response) {
            send(BLECommand.continuousHR(mode: HistorySyncMode.continueSync, start: nil))
        }
    }

    private func appendSingle(_ response: ParsedDeviceResponse) {
        if let items = response.dictionary["arraySingleHR"] as? [[String: Any]] {
            for item in items {
                displayText += "date: \(SDKHelpers.stringValue(item["date"]))\nHR: \(SDKHelpers.stringValue(item["singleHR"]))\n\n"
            }
        }
        handlePagination(response) {
            send(BLECommand.singleHR(mode: HistorySyncMode.continueSync, start: nil))
        }
    }

    private func handlePagination(_ response: ParsedDeviceResponse, continueSync: () -> Void) {
        if pagination.recordBatch(isEnd: response.isEnd) {
            continueSync()
        } else if response.isEnd {
            if displayText.isEmpty { displayText = "No data\n" }
            statusMessage = "Sync complete"
        }
    }
}
