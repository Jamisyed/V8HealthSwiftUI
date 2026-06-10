//
//  ActivityHistoryViewModel.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

enum ActivityHistoryMode: String, CaseIterable, Identifiable {
    case total = "Total"
    case detail = "Detail"
    case sportType = "Sport Type"

    var id: String { rawValue }
}

@MainActor
@Observable
final class ActivityHistoryViewModel: ResponseHandlingViewModel {
    var mode: ActivityHistoryMode = .total
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
        send(startCommand(mode: HistorySyncMode.start))
    }

    func deleteAll() {
        send(startCommand(mode: HistorySyncMode.deleteAll))
        displayText = "Delete command sent.\n"
        statusMessage = "Delete requested"
    }

    func handleResponse(_ response: ParsedDeviceResponse) {
        switch response.dataType {
        case .totalActivityData:
            appendTotal(response)
        case .detailActivityData:
            appendDetail(response)
        case .activityModeData:
            appendSport(response)
        default:
            break
        }
    }

    private func appendTotal(_ response: ParsedDeviceResponse) {
        if let items = response.dictionary["arrayTotalActivityData"] as? [[String: Any]] {
            for item in items {
                displayText += """
                date: \(SDKHelpers.stringValue(item["date"]))
                step: \(SDKHelpers.stringValue(item["step"]))
                distance: \(SDKHelpers.stringValue(item["distance"]))
                calories: \(SDKHelpers.stringValue(item["calories"]))
                exercise: \(SDKHelpers.stringValue(item["exerciseMinutes"]))
                active: \(SDKHelpers.stringValue(item["activeMinutes"]))
                goal: \(SDKHelpers.stringValue(item["goal"]))

                """
            }
        }
        paginate(response) { send(BLECommand.totalActivity(mode: HistorySyncMode.continueSync, start: nil)) }
    }

    private func appendDetail(_ response: ParsedDeviceResponse) {
        if let items = response.dictionary["arrayDetailActivityData"] as? [[String: Any]] {
            for item in items {
                let steps = (item["arraySteps"] as? [Any])?.map { "\($0)" }.joined(separator: ", ") ?? ""
                displayText += """
                date: \(SDKHelpers.stringValue(item["date"]))
                step: \(SDKHelpers.stringValue(item["step"]))
                calories: \(SDKHelpers.stringValue(item["calories"]))
                distance: \(SDKHelpers.stringValue(item["distance"]))
                steps: \(steps)

                """
            }
        }
        paginate(response) { send(BLECommand.detailActivity(mode: HistorySyncMode.continueSync, start: nil)) }
    }

    private func appendSport(_ response: ParsedDeviceResponse) {
        if let items = response.dictionary["arrayActivityModeData"] as? [[String: Any]] {
            for item in items {
                displayText += """
                date: \(SDKHelpers.stringValue(item["date"]))
                mode: \(SDKHelpers.stringValue(item["activityMode"]))
                HR: \(SDKHelpers.stringValue(item["heartRate"]))
                step: \(SDKHelpers.stringValue(item["step"]))
                calories: \(SDKHelpers.stringValue(item["calories"]))
                distance: \(SDKHelpers.stringValue(item["distance"]))

                """
            }
        }
        paginate(response) { send(BLECommand.activityModeHistory(mode: HistorySyncMode.continueSync, start: nil, needMETS: false)) }
    }

    private func paginate(_ response: ParsedDeviceResponse, continueSync: () -> Void) {
        if pagination.recordBatch(isEnd: response.isEnd) {
            continueSync()
        } else if response.isEnd {
            if displayText.isEmpty { displayText = "No data\n" }
            statusMessage = "Sync complete"
        }
    }

    private func startCommand(mode: Int) -> Data? {
        switch self.mode {
        case .total:
            return BLECommand.totalActivity(mode: mode, start: nil)
        case .detail:
            return BLECommand.detailActivity(mode: mode, start: nil)
        case .sportType:
            return BLECommand.activityModeHistory(mode: mode, start: nil, needMETS: false)
        }
    }
}
