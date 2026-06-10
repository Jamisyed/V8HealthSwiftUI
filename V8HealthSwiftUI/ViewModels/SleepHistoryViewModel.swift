//
//  SleepHistoryViewModel.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

enum SleepHistoryMode: String, CaseIterable, Identifiable {
    case sleepOnly = "Sleep"
    case sleepAndActivity = "Sleep + Activity"

    var id: String { rawValue }
}

@MainActor
@Observable
final class SleepHistoryViewModel: ResponseHandlingViewModel {
    var mode: SleepHistoryMode = .sleepOnly
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
        send(command(mode: HistorySyncMode.start))
    }

    func deleteAll() {
        send(command(mode: HistorySyncMode.deleteAll))
        displayText = "Delete command sent.\n"
        statusMessage = "Delete requested"
    }

    func handleResponse(_ response: ParsedDeviceResponse) {
        switch response.dataType {
        case .detailSleepData:
            appendSleep(response)
        case .detailSleepAndActivityData:
            appendSleepAndActivity(response)
        default:
            break
        }
    }

    private func appendSleep(_ response: ParsedDeviceResponse) {
        if let items = response.dictionary["arrayDetailSleepData"] as? [[String: Any]] {
            for item in items {
                let quality = (item["arraySleepQuality"] as? [Any])?.map { "\($0)" }.joined(separator: ", ") ?? ""
                displayText += """
                start: \(SDKHelpers.stringValue(item["startTime_SleepData"]))
                total: \(SDKHelpers.stringValue(item["totalSleepTime"]))
                quality: \(quality)
                unit: \(SDKHelpers.stringValue(item["sleepUnitLength"]))

                """
            }
        }
        paginate(response) { send(BLECommand.detailSleep(mode: HistorySyncMode.continueSync, start: nil)) }
    }

    private func appendSleepAndActivity(_ response: ParsedDeviceResponse) {
        if let items = response.dictionary["arrayDetailSleepAndActivityData"] as? [[String: Any]] {
            for item in items {
                displayText += "record: \(item)\n\n"
            }
        }
        paginate(response) { send(BLECommand.sleepAndActivity(mode: HistorySyncMode.continueSync, start: nil)) }
    }

    private func paginate(_ response: ParsedDeviceResponse, continueSync: () -> Void) {
        if pagination.recordBatch(isEnd: response.isEnd) {
            continueSync()
        } else if response.isEnd {
            if displayText.isEmpty { displayText = "No data\n" }
            statusMessage = "Sync complete"
        }
    }

    private func command(mode: Int) -> Data? {
        switch self.mode {
        case .sleepOnly:
            return BLECommand.detailSleep(mode: mode, start: nil)
        case .sleepAndActivity:
            return BLECommand.sleepAndActivity(mode: mode, start: nil)
        }
    }
}
