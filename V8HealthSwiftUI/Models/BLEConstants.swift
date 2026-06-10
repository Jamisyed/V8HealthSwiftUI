//
//  BLEConstants.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

enum BLEConstants {
    static let service = "FFF0"
    static let sendChar = "FFF6"
    static let receiveChar = "FFF7"
}

enum SDKDataType: Int {
    case getDeviceTime = 0
    case setDeviceTime = 1
    case getPersonalInfo = 2
    case setPersonalInfo = 3
    case getDeviceGoal = 7
    case setDeviceGoal = 8
    case getDeviceBattery = 9
    case getDeviceMacAddress = 10
    case getDeviceVersion = 11
    case factoryReset = 12
    case mcuReset = 13
    case getAutomaticMonitoring = 17
    case setAutomaticMonitoring = 18
    case getAlarmClock = 19
    case setAlarmClock = 20
    case deleteAllAlarmClock = 21
    case realTimeStep = 24
    case totalActivityData = 25
    case detailActivityData = 26
    case detailSleepData = 27
    case dynamicHR = 28
    case staticHR = 29
    case activityModeData = 30
    case startActivityMode = 31
    case stopActivityMode = 32
    case pauseActivityMode = 33
    case continueActivityMode = 34
    case getActivityMode = 35
    case deviceSendDataToApp = 36
    case hrvData = 41
    case automaticSpo2Data = 45
    case manualSpo2Data = 46
    case findMobilePhone = 47
    case temperatureData = 48
    case sos = 50
    case ecgRawData = 54
    case deviceMeasurement = 80
    case detailSleepAndActivityData = 81
    case ppiData = 82
    case openRRInterval = 66
    case closeRRInterval = 67
    case realtimeRRIntervalData = 68
    case dataError = 255

    init?(raw: Int) {
        self.init(rawValue: raw)
    }
}

struct ParsedDeviceResponse {
    let dataType: SDKDataType?
    let rawDataType: Int
    let dictionary: [String: Any]
    let isEnd: Bool
}

struct PersonalInfoModel: Equatable {
    var gender: Int = 1
    var age: Int = 30
    var height: Int = 170
    var weight: Int = 70
    var stride: Int = 75
}

struct AutomaticMonitoringModel: Equatable {
    var isEnabled = false
    var startHour = 8
    var startMinute = 0
    var endHour = 22
    var endMinute = 0
    var intervalMinutes = 30
    var dataType = 1
    var sunday = true
    var monday = true
    var tuesday = true
    var wednesday = true
    var thursday = true
    var friday = true
    var saturday = true
}

struct RealtimeMetrics: Equatable {
    var steps = "—"
    var calories = "—"
    var distance = "—"
    var exerciseTime = "—"
    var strengthTime = "—"
    var heartRate = "—"
    var spo2 = "—"
}

struct ActivityModeMetrics: Equatable {
    var steps = "—"
    var heartRate = "—"
    var calories = "—"
    var activeMinutes = "—"
}

struct AlarmClockItem: Identifiable, Equatable {
    let id: UUID
    var openOrClose: Bool
    var clockType: Int
    var hour: Int
    var minute: Int
    var weekBitmask: Int
    var label: String

    init(
        id: UUID = UUID(),
        openOrClose: Bool = true,
        clockType: Int = 1,
        hour: Int = 8,
        minute: Int = 0,
        weekBitmask: Int = 0x7F,
        label: String = ""
    ) {
        self.id = id
        self.openOrClose = openOrClose
        self.clockType = clockType
        self.hour = hour
        self.minute = minute
        self.weekBitmask = weekBitmask
        self.label = label
    }

    static func fromDictionary(_ dict: [String: Any]) -> AlarmClockItem {
        let time = SDKHelpers.stringValue(dict["clockTime"])
        let parts = time.split(separator: ":")
        let hour = parts.count > 0 ? Int(parts[0]) ?? 8 : 8
        let minute = parts.count > 1 ? Int(parts[1]) ?? 0 : 0
        return AlarmClockItem(
            openOrClose: SDKHelpers.boolValue(dict["openOrClose"], default: true),
            clockType: SDKHelpers.intValue(dict["clockType"], default: 1),
            hour: hour,
            minute: minute,
            weekBitmask: SDKHelpers.intValue(dict["week"], default: 0x7F),
            label: SDKHelpers.stringValue(dict["text"])
        )
    }

    func toDictionary() -> [String: Any] {
        [
            "openOrClose": openOrClose,
            "clockType": clockType,
            "clockTime": String(format: "%02d:%02d", hour, minute),
            "week": weekBitmask,
            "textLenght": label.count,
            "text": label,
        ]
    }
}

enum FeatureDocType: String, Identifiable {
    case deviceTime
    case autoMeasurement
    case realtimeStep
    case activity
    case sleep
    case heartRate
    case temperature
    case spo2
    case hrv
    case activityMode

    var id: String { rawValue }

    var title: String {
        switch self {
        case .deviceTime: return "Device Time"
        case .autoMeasurement: return "Auto Measurement"
        case .realtimeStep: return "Real-time Steps"
        case .activity: return "Activity History"
        case .sleep: return "Sleep History"
        case .heartRate: return "Heart Rate History"
        case .temperature: return "Temperature History"
        case .spo2: return "SpO2 History"
        case .hrv: return "HRV History"
        case .activityMode: return "Activity Mode"
        }
    }

    var body: String {
        switch self {
        case .deviceTime:
            return "GetDeviceTime / SetDeviceTime sync the watch clock with the phone."
        case .autoMeasurement:
            return "SetAutomaticHRMonitoring configures scheduled HR, SpO2, temperature, or HRV sampling."
        case .realtimeStep:
            return "RealTimeDataWithType uploads live steps. manualMeasurementWithDataType starts manual HR or SpO2."
        case .activity:
            return "GetTotalActivityData, GetDetailActivityData, and GetActivityModeData support mode 0 start, mode 2 continue, and 0x99 delete."
        case .sleep:
            return "GetDetailSleepData and getSleepDetailsAndActivity sync sleep records with pagination."
        case .heartRate:
            return "GetContinuousHRData and GetSingleHRData return historical HR batches of up to 50 records."
        case .temperature:
            return "GetTemperatureDataWithMode returns ring temperature history."
        case .spo2:
            return "GetAutomaticSpo2DataWithMode returns automatic SpO2 history."
        case .hrv:
            return "GetHRVDataWithMode returns HRV, stress, HR, and blood pressure estimates."
        case .activityMode:
            return "startActivityMode enters live sport mode. DeviceSendDataToAPP_V8 streams live metrics."
        }
    }
}
