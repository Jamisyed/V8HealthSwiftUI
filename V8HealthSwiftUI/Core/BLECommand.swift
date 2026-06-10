//
//  BLECommand.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

enum BLECommand {
    private static let sdk = BleSDK_V8.sharedManager()!

    static func getDeviceTime() -> Data? { sdk.getDeviceTime() as Data? }
    static func setDeviceTime(_ time: MyDeviceTime_V8) -> Data? { sdk.setDeviceTime(time) as Data? }
    static func getPersonalInfo() -> Data? { sdk.getPersonalInfo() as Data? }
    static func setPersonalInfo(_ info: MyPersonalInfo_V8) -> Data? { sdk.setPersonalInfo(info) as Data? }
    static func getStepGoal() -> Data? { sdk.getStepGoal() as Data? }
    static func setStepGoal(_ goal: Int) -> Data? { sdk.setStepGoal(Int32(goal)) as Data? }
    static func getBattery() -> Data? { sdk.getDeviceBatteryLevel() as Data? }
    static func getMacAddress() -> Data? { sdk.getDeviceMacAddress() as Data? }
    static func getVersion() -> Data? { sdk.getDeviceVersion() as Data? }
    static func factoryReset() -> Data? { sdk.reset() as Data? }
    static func mcuReset() -> Data? { sdk.mcuReset() as Data? }

    static func getAutomaticMonitoring(dataType: Int) -> Data? {
        sdk.getAutomaticMonitoring(withDataType: Int32(dataType)) as Data?
    }

    static func setAutomaticMonitoring(_ config: MyAutomaticMonitoring_V8) -> Data? {
        sdk.setAutomaticHRMonitoring(config) as Data?
    }

    static func realTimeData(enabled: Bool) -> Data? {
        sdk.realTimeData(withType: enabled ? 1 : 0) as Data?
    }

    static func manualMeasurement(type: MeasurementDataType_V8, seconds: Int, open: Bool) -> Data? {
        sdk.manualMeasurement(withDataType: type, measurementTime: Int32(seconds), open: open) as Data?
    }

    static func setECGRealtime(enabled: Bool) -> Data? {
        sdk.setECGRealtimeDuringHRVEnabled(enabled) as Data?
    }

    static func totalActivity(mode: Int, start: Date?) -> Data? {
        sdk.getTotalActivityData(withMode: Int32(mode), withStart: start) as Data?
    }

    static func detailActivity(mode: Int, start: Date?) -> Data? {
        sdk.getDetailActivityData(withMode: Int32(mode), withStart: start) as Data?
    }

    static func activityModeHistory(mode: Int, start: Date?, needMETS: Bool) -> Data? {
        sdk.getActivityModeData(withMode: Int32(mode), withStart: start, needMETS: needMETS) as Data?
    }

    static func detailSleep(mode: Int, start: Date?) -> Data? {
        sdk.getDetailSleepData(withMode: Int32(mode), withStart: start) as Data?
    }

    static func sleepAndActivity(mode: Int, start: Date?) -> Data? {
        sdk.getSleepDetailsAndActivity(withMode: Int32(mode), withStart: start) as Data?
    }

    static func continuousHR(mode: Int, start: Date?) -> Data? {
        sdk.getContinuousHRData(withMode: Int32(mode), withStart: start) as Data?
    }

    static func singleHR(mode: Int, start: Date?) -> Data? {
        sdk.getSingleHRData(withMode: Int32(mode), withStart: start) as Data?
    }

    static func temperature(mode: Int, start: Date?) -> Data? {
        sdk.getTemperatureData(withMode: Int32(mode), withStart: start) as Data?
    }

    static func automaticSpo2(mode: Int, start: Date?) -> Data? {
        sdk.getAutomaticSpo2Data(withMode: Int32(mode), withStart: start) as Data?
    }

    static func hrv(mode: Int, start: Date?) -> Data? {
        sdk.getHRVData(withMode: Int32(mode), withStart: start) as Data?
    }

    static func ppi(mode: Int, start: Date?) -> Data? {
        sdk.getPPIData(withMode: Int32(mode), withStart: start) as Data?
    }

    static func getAlarms() -> Data? { sdk.getAlarmClock() as Data? }
    static func deleteAllAlarms() -> Data? { sdk.deleteAllAlarmClock() as Data? }

    static func setAlarms(_ alarms: [[String: Any]]) -> [Data] {
        let payload = alarms.map { $0 as [AnyHashable: Any] }
        let packets = sdk.setAlarmClock(withAllClock: payload) as? [NSData] ?? []
        return packets.map { $0 as Data }
    }

    static func startActivity(
        mode: ACTIVITYMODE_V8,
        workMode: WORKMODE_V8,
        minutes: Int,
        breath: MyBreathParameter_V8
    ) -> Data? {
        sdk.startActivityMode(mode, workMode: workMode, activityTime: Int32(minutes), breathParameter: breath) as Data?
    }

    static func hrvMeasurement(open: Bool) -> Data? {
        sdk.manualMeasurement(withDataType: .hrvData_v8, measurementTime: 300, open: open) as Data?
    }
}
