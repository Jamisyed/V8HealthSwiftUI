//
//  ViewModelSubscription.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

@MainActor
protocol ResponseHandlingViewModel: AnyObject {
    func handleResponse(_ response: ParsedDeviceResponse)
}

extension ResponseHandlingViewModel {
    func subscribeToDevice() {
        V8BLEClient.shared.onParsedResponse = { [weak self] response in
            self?.handleResponse(response)
        }
    }

    func unsubscribeFromDevice() {
        if V8BLEClient.shared.onParsedResponse != nil {
            V8BLEClient.shared.onParsedResponse = nil
        }
    }

    func send(_ data: Data?) {
        do {
            try V8BLEClient.shared.send(data)
        } catch {
            let message = error.localizedDescription
            V8BLEClient.shared.lastMessage = message
            AppLogger.error("BLE send failed", context: "BLE", metadata: ["error": message])
        }
    }

    func sendAll(_ packets: [Data]) {
        do {
            try V8BLEClient.shared.sendAll(packets)
        } catch {
            let message = error.localizedDescription
            V8BLEClient.shared.lastMessage = message
            AppLogger.error("BLE sendAll failed", context: "BLE", metadata: ["error": message, "packets": packets.count])
        }
    }
}
