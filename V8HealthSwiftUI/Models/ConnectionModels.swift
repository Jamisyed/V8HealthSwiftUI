//
//  ConnectionModels.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation
import CoreBluetooth

struct ConnectionState: Equatable {
    var isScanning = false
    var isConnected = false
    var isReady = false
    var status = "Not connected"
}

struct ScannedDevice: Identifiable, Equatable {
    let id: UUID
    let name: String
    let rssi: Int
    let peripheral: CBPeripheral

    static func == (lhs: ScannedDevice, rhs: ScannedDevice) -> Bool {
        lhs.id == rhs.id
    }
}

enum DashboardRoute: Hashable {
    case deviceTime
    case personalInfo
    case stepGoal
    case deviceInfo
    case autoMeasurement
    case realtimeData
    case activityHistory
    case sleepHistory
    case heartRate
    case temperature
    case spo2
    case hrv
    case ecg
    case logExport
    case activityMode
    case ppi
    case alarms
}

struct DashboardSection: Identifiable {
    let id: String
    let title: String
    let items: [(icon: String, title: String, route: DashboardRoute)]
}

enum DashboardCatalog {
    static let sections: [DashboardSection] = [
        DashboardSection(id: "settings", title: "Settings", items: [
            ("clock.fill", "Device Time", .deviceTime),
            ("person.fill", "Personal Info", .personalInfo),
            ("target", "Step Goal", .stepGoal),
            ("heart.fill", "Device Info", .deviceInfo),
            ("timer", "Auto Measurement", .autoMeasurement),
        ]),
        DashboardSection(id: "live", title: "Live Data", items: [
            ("figure.walk", "Real-time Steps", .realtimeData),
            ("sportscourt.fill", "Activity Mode", .activityMode),
            ("waveform.path.ecg", "ECG", .ecg),
        ]),
        DashboardSection(id: "history", title: "History", items: [
            ("chart.bar.fill", "Activity", .activityHistory),
            ("bed.double.fill", "Sleep", .sleepHistory),
            ("waveform.path.ecg", "Heart Rate", .heartRate),
            ("thermometer.medium", "Temperature", .temperature),
            ("lungs.fill", "Blood Oxygen", .spo2),
            ("heart.text.square.fill", "HRV", .hrv),
            ("heart.circle.fill", "PPI", .ppi),
        ]),
        DashboardSection(id: "other", title: "Other", items: [
            ("alarm.fill", "Alarms", .alarms),
            ("doc.text.fill", "Log Export", .logExport),
        ]),
    ]
}
