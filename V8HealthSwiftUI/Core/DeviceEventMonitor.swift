//
//  DeviceEventMonitor.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

@MainActor
@Observable
final class DeviceEventMonitor {
    static let shared = DeviceEventMonitor()

    var alertTitle: String?
    var alertMessage: String?
    var showAlert = false

    private init() {}

    func handle(_ response: ParsedDeviceResponse) {
        switch response.dataType {
        case .findMobilePhone:
            present(title: "Find Phone", message: "The device is looking for your phone.")
        case .sos:
            present(title: "SOS", message: "SOS alert received from the device.")
        default:
            break
        }
    }

    private func present(title: String, message: String) {
        AppLogger.warning(title, context: "DeviceEvent", metadata: ["message": message])
        alertTitle = title
        alertMessage = message
        showAlert = true
    }

    func dismissAlert() {
        showAlert = false
        alertTitle = nil
        alertMessage = nil
    }
}
