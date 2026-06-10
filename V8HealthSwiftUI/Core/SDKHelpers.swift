//
//  SDKHelpers.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

enum SDKHelpers {
    static func intValue(_ value: Any?, default defaultValue: Int = 0) -> Int {
        if let n = value as? NSNumber { return n.intValue }
        if let i = value as? Int { return i }
        return defaultValue
    }

    static func boolValue(_ value: Any?, default defaultValue: Bool = false) -> Bool {
        if let n = value as? NSNumber { return n.boolValue }
        if let b = value as? Bool { return b }
        return defaultValue
    }

    static func stringValue(_ value: Any?) -> String {
        guard let value else { return "—" }
        return "\(value)"
    }

    static func deviceTime(from date: Date) -> MyDeviceTime_V8 {
        let cal = Calendar.current
        var native = MyDeviceTime_V8()
        native.year = Int32(cal.component(.year, from: date))
        native.month = Int32(cal.component(.month, from: date))
        native.day = Int32(cal.component(.day, from: date))
        native.hour = Int32(cal.component(.hour, from: date))
        native.minute = Int32(cal.component(.minute, from: date))
        native.second = Int32(cal.component(.second, from: date))
        return native
    }

    static func personalInfo(from model: PersonalInfoModel) -> MyPersonalInfo_V8 {
        var native = MyPersonalInfo_V8()
        native.gender = Int32(model.gender)
        native.age = Int32(model.age)
        native.height = Int32(model.height)
        native.weight = Int32(model.weight)
        native.stride = Int32(model.stride)
        return native
    }
}

enum HistorySyncMode {
    static let start = 0
    static let continueSync = 2
    static let deleteAll = 0x99
}
