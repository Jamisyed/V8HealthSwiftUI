//
//  RealtimeDataViewModel.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

@MainActor
@Observable
final class RealtimeDataViewModel: ResponseHandlingViewModel {
    var metrics = RealtimeMetrics()
    var realtimeStepsEnabled = false
    var manualHREnabled = false
    var manualSpO2Enabled = false
    var statusMessage = ""

    func onAppear() {
        subscribeToDevice()
    }

    func onDisappear() {
        if realtimeStepsEnabled { setRealtimeSteps(false) }
        if manualHREnabled { setManualHR(false) }
        if manualSpO2Enabled { setManualSpO2(false) }
        unsubscribeFromDevice()
    }

    func setRealtimeSteps(_ enabled: Bool) {
        realtimeStepsEnabled = enabled
        send(BLECommand.realTimeData(enabled: enabled))
        statusMessage = enabled ? "Real-time steps on" : "Real-time steps off"
    }

    func setManualHR(_ enabled: Bool) {
        manualHREnabled = enabled
        send(BLECommand.manualMeasurement(type: .heartRateData_V8, seconds: 30, open: enabled))
        statusMessage = enabled ? "Manual HR on" : "Manual HR off"
    }

    func setManualSpO2(_ enabled: Bool) {
        manualSpO2Enabled = enabled
        send(BLECommand.manualMeasurement(type: .spo2Data_V8, seconds: 30, open: enabled))
        statusMessage = enabled ? "Manual SpO2 on" : "Manual SpO2 off"
    }

    func handleResponse(_ response: ParsedDeviceResponse) {
        guard response.dataType == .realTimeStep else { return }
        metrics = RealtimeMetrics(
            steps: SDKHelpers.stringValue(response.dictionary["step"]),
            calories: SDKHelpers.stringValue(response.dictionary["calories"]),
            distance: SDKHelpers.stringValue(response.dictionary["distance"]),
            exerciseTime: SDKHelpers.stringValue(response.dictionary["time"]),
            strengthTime: SDKHelpers.stringValue(response.dictionary["StrengthTrainingTime"]),
            heartRate: SDKHelpers.stringValue(response.dictionary["heartRate"]),
            spo2: SDKHelpers.stringValue(response.dictionary["spo2"])
        )
    }
}
