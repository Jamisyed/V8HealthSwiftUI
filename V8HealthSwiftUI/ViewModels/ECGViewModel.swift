//
//  ECGViewModel.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

@MainActor
@Observable
final class ECGViewModel: ResponseHandlingViewModel {
    var isMeasuring = false
    var ecgSamples: [Double] = []
    var packetLoss = "0"
    var packetLoss5s = "0"
    var minValue = "—"
    var maxValue = "—"
    var statusMessage = ""

    private var lastPacketID: Int?
    private var lostCount = 0
    private var recentLossTimestamps: [Date] = []

    func onAppear() {
        subscribeToDevice()
    }

    func onDisappear() {
        if isMeasuring { stopMeasurement() }
        unsubscribeFromDevice()
    }

    func startMeasurement() {
        isMeasuring = true
        ecgSamples.removeAll()
        lastPacketID = nil
        lostCount = 0
        recentLossTimestamps.removeAll()
        send(BLECommand.hrvMeasurement(open: true))
        statusMessage = "HRV measurement started"
    }

    func stopMeasurement() {
        isMeasuring = false
        send(BLECommand.hrvMeasurement(open: false))
        send(BLECommand.setECGRealtime(enabled: false))
        statusMessage = "Measurement stopped"
    }

    func handleResponse(_ response: ParsedDeviceResponse) {
        switch response.dataType {
        case .deviceMeasurement:
            send(BLECommand.setECGRealtime(enabled: true))
            statusMessage = "ECG streaming enabled"
        case .ecgRawData:
            appendECG(response)
        default:
            break
        }
    }

    private func appendECG(_ response: ParsedDeviceResponse) {
        let packetID = SDKHelpers.intValue(response.dictionary["packetID"])
        if let lastPacketID, packetID > lastPacketID + 1 {
            let missed = packetID - lastPacketID - 1
            lostCount += missed
            recentLossTimestamps.append(Date())
        }
        self.lastPacketID = packetID

        recentLossTimestamps.removeAll { Date().timeIntervalSince($0) > 5 }
        packetLoss = "\(lostCount)"
        packetLoss5s = "\(recentLossTimestamps.count)"

        if let raw = response.dictionary["arrayEcgRawData"] as? [NSNumber] {
            let values = raw.map(\.doubleValue)
            ecgSamples.append(contentsOf: values)
            if let minSample = values.min() { minValue = String(format: "%.0f", minSample) }
            if let maxSample = values.max() { maxValue = String(format: "%.0f", maxSample) }
            if ecgSamples.count > 3000 {
                ecgSamples.removeFirst(ecgSamples.count - 3000)
            }
        }
    }
}
