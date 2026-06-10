//
//  DeviceInfoViewModel.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

@MainActor
@Observable
final class DeviceInfoViewModel: ResponseHandlingViewModel {
    var batteryLevel = "—"
    var deviceVersion = "—"
    var macAddress = "—"
    var statusMessage = ""
    var showFactoryResetConfirm = false
    var showMCUResetConfirm = false

    func onAppear() {
        subscribeToDevice()
        refreshAll()
    }

    func onDisappear() {
        unsubscribeFromDevice()
    }

    func refreshAll() {
        send(BLECommand.getBattery())
        send(BLECommand.getVersion())
        send(BLECommand.getMacAddress())
    }

    func fetchBattery() { send(BLECommand.getBattery()) }
    func fetchVersion() { send(BLECommand.getVersion()) }
    func fetchMacAddress() { send(BLECommand.getMacAddress()) }

    func factoryReset() {
        send(BLECommand.factoryReset())
    }

    func mcuReset() {
        send(BLECommand.mcuReset())
    }

    func handleResponse(_ response: ParsedDeviceResponse) {
        switch response.dataType {
        case .getDeviceBattery:
            batteryLevel = "\(SDKHelpers.stringValue(response.dictionary["batteryLevel"]))%"
            statusMessage = "Battery updated"
        case .getDeviceVersion:
            deviceVersion = SDKHelpers.stringValue(response.dictionary["deviceVersion"])
            statusMessage = "Version received"
        case .getDeviceMacAddress:
            macAddress = SDKHelpers.stringValue(response.dictionary["macAddress"])
            statusMessage = "MAC received"
        case .factoryReset:
            statusMessage = "Factory reset sent"
        case .mcuReset:
            statusMessage = "MCU reset sent"
        default:
            break
        }
    }
}
