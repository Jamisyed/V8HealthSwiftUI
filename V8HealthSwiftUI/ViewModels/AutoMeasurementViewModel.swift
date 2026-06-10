//
//  AutoMeasurementViewModel.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

@MainActor
@Observable
final class AutoMeasurementViewModel: ResponseHandlingViewModel {
    var config = AutomaticMonitoringModel()
    var statusMessage = ""

    let intervalOptions = Array(stride(from: 5, through: 120, by: 5))

    func onAppear() {
        subscribeToDevice()
        loadFromDevice()
    }

    func onDisappear() {
        unsubscribeFromDevice()
    }

    func loadFromDevice() {
        send(BLECommand.getAutomaticMonitoring(dataType: config.dataType))
    }

    func saveToDevice() {
        send(BLECommand.setAutomaticMonitoring(makeNativeConfig()))
    }

    func handleResponse(_ response: ParsedDeviceResponse) {
        switch response.dataType {
        case .getAutomaticMonitoring:
            config.isEnabled = SDKHelpers.intValue(response.dictionary["workMode"]) != 0
            config.startHour = SDKHelpers.intValue(response.dictionary["startTime_Hour"], default: 8)
            config.startMinute = SDKHelpers.intValue(response.dictionary["startTime_Minutes"])
            config.endHour = SDKHelpers.intValue(response.dictionary["endTime_Hour"], default: 22)
            config.endMinute = SDKHelpers.intValue(response.dictionary["endTime_Minutes"])
            config.intervalMinutes = SDKHelpers.intValue(response.dictionary["intervalTime"], default: 30)
            config.dataType = SDKHelpers.intValue(response.dictionary["dataType"], default: 1)
            if let weeks = response.dictionary["weeks"] as? [String: Any] {
                config.sunday = SDKHelpers.boolValue(weeks["sunday"], default: true)
                config.monday = SDKHelpers.boolValue(weeks["monday"], default: true)
                config.tuesday = SDKHelpers.boolValue(weeks["Tuesday"], default: true)
                config.wednesday = SDKHelpers.boolValue(weeks["Wednesday"], default: true)
                config.thursday = SDKHelpers.boolValue(weeks["Thursday"], default: true)
                config.friday = SDKHelpers.boolValue(weeks["Friday"], default: true)
                config.saturday = SDKHelpers.boolValue(weeks["Saturday"], default: true)
            }
            statusMessage = "Auto measurement loaded"
        case .setAutomaticMonitoring:
            statusMessage = "Auto measurement saved"
        default:
            break
        }
    }

    private func makeNativeConfig() -> MyAutomaticMonitoring_V8 {
        var native = MyAutomaticMonitoring_V8()
        native.mode = config.isEnabled ? 2 : 0
        native.startTime_Hour = Int32(config.startHour)
        native.startTime_Minutes = Int32(config.startMinute)
        native.endTime_Hour = Int32(config.endHour)
        native.endTime_Minutes = Int32(config.endMinute)
        native.intervalTime = Int32(config.intervalMinutes)
        native.dataType = Int32(config.dataType)
        native.weeks = makeWeeks()
        return native
    }

    private func makeWeeks() -> MyWeeks_V8 {
        var weeks = MyWeeks_V8()
        weeks.sunday = ObjCBool(config.sunday)
        weeks.monday = ObjCBool(config.monday)
        weeks.Tuesday = ObjCBool(config.tuesday)
        weeks.Wednesday = ObjCBool(config.wednesday)
        weeks.Thursday = ObjCBool(config.thursday)
        weeks.Friday = ObjCBool(config.friday)
        weeks.Saturday = ObjCBool(config.saturday)
        return weeks
    }
}
