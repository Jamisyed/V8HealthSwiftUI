//
//  DeviceTimeViewModel.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

@MainActor
@Observable
final class DeviceTimeViewModel: ResponseHandlingViewModel {
    var selectedDate = Date()
    var deviceTimeText = "—"
    var statusMessage = ""

    func onAppear() {
        subscribeToDevice()
        loadFromDevice()
    }

    func onDisappear() {
        unsubscribeFromDevice()
    }

    func loadFromDevice() {
        send(BLECommand.getDeviceTime())
    }

    func syncPhoneTime() {
        send(BLECommand.setDeviceTime(SDKHelpers.deviceTime(from: Date())))
    }

    func saveSelectedTime() {
        send(BLECommand.setDeviceTime(SDKHelpers.deviceTime(from: selectedDate)))
    }

    func handleResponse(_ response: ParsedDeviceResponse) {
        switch response.dataType {
        case .getDeviceTime:
            deviceTimeText = SDKHelpers.stringValue(response.dictionary["deviceTime"])
            statusMessage = "Device time loaded"
        case .setDeviceTime:
            statusMessage = "Device time set"
            loadFromDevice()
        default:
            break
        }
    }
}
