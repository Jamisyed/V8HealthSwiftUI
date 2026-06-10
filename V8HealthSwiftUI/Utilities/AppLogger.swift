//
//  AppLogger.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

enum AppLogger {

    private static let maxReleaseValueLength = 500

    enum Level: String {
        case debug = "DEBUG"
        case info = "INFO"
        case warning = "WARNING"
        case error = "ERROR"
        case critical = "CRITICAL"
    }

    static func log(
        level: Level,
        message: String,
        context: String = "App",
        metadata: [String: Any?] = [:],
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        guard shouldLog(level) else { return }

        let logMessage = format(
            level: level,
            message: message,
            context: context,
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )

        #if DEBUG
        print(logMessage)
        #else
        NSLog("%@", logMessage)
        #endif
    }

    static func debug(
        _ message: String,
        context: String = "App",
        metadata: [String: Any?] = [:],
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .debug, message: message, context: context, metadata: metadata, file: file, function: function, line: line)
    }

    static func info(
        _ message: String,
        context: String = "App",
        metadata: [String: Any?] = [:],
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .info, message: message, context: context, metadata: metadata, file: file, function: function, line: line)
    }

    static func warning(
        _ message: String,
        context: String = "App",
        metadata: [String: Any?] = [:],
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .warning, message: message, context: context, metadata: metadata, file: file, function: function, line: line)
    }

    static func error(
        _ message: String,
        context: String = "App",
        metadata: [String: Any?] = [:],
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .error, message: message, context: context, metadata: metadata, file: file, function: function, line: line)
    }

    static func critical(
        _ message: String,
        context: String = "App",
        metadata: [String: Any?] = [:],
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .critical, message: message, context: context, metadata: metadata, file: file, function: function, line: line)
    }

    static func logBLE(
        level: Level,
        message: String,
        context: String = "BLE",
        metadata: [String: Any?] = [:],
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: level, message: message, context: context, metadata: metadata, file: file, function: function, line: line)
    }

    static func logParsedResponse(
        _ response: ParsedDeviceResponse,
        context: String = "BLE",
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        let level: Level
        if response.dataType == .dataError {
            level = .error
        } else if response.dataType == .sos {
            level = .critical
        } else if response.dataType == .findMobilePhone {
            level = .warning
        } else {
            level = .debug
        }

        let metadata: [String: Any?] = [
            "dataType": response.dataType?.rawValue ?? response.rawDataType,
            "isEnd": response.isEnd,
            "keys": response.dictionary.keys.sorted().joined(separator: ",")
        ]

        logBLE(
            level: level,
            message: "Device response",
            context: context,
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )
    }

    private static func shouldLog(_ level: Level) -> Bool {
        #if DEBUG
        return true
        #else
        switch level {
        case .debug, .info:
            return false
        case .warning, .error, .critical:
            return true
        }
        #endif
    }

    private static func format(
        level: Level,
        message: String,
        context: String,
        metadata: [String: Any?],
        file: String,
        function: String,
        line: Int
    ) -> String {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let metadataText = formatMetadata(metadata)

        return """
        ==================== \(context) ====================
        Time: \(timestamp)
        Level: \(level.rawValue)
        Message: \(message)
        Location: \(file)
        Function: \(function)
        Line: \(line)
        Metadata: \(metadataText)
        ==================== END ============================
        """
    }

    private static func formatMetadata(_ metadata: [String: Any?]) -> String {
        guard !metadata.isEmpty else { return "N/A" }

        return metadata
            .sorted { $0.key < $1.key }
            .map { key, value in
                "\(key)=\(sanitizeValue(value))"
            }
            .joined(separator: " | ")
    }

    private static func sanitizeValue(_ value: Any?) -> String {
        guard let value else { return "N/A" }
        return trimIfNeeded(redactSensitiveData(String(describing: value)))
    }

    private static func redactSensitiveData(_ value: String) -> String {
        var redacted = value
        let redactionRules = [
            (#"(?i)("macAddress"\s*:\s*")[^"]+(")"#, "$1<redacted>$2"),
            (#"(?i)(macAddress=)[^;\s|]+"#, "$1<redacted>"),
            (#"(?i)("weight"\s*:\s*")[^"]+(")"#, "$1<redacted>$2"),
            (#"(?i)("height"\s*:\s*")[^"]+(")"#, "$1<redacted>$2"),
            (#"(?i)("age"\s*:\s*")[^"]+(")"#, "$1<redacted>$2"),
            (#"(?i)("gender"\s*:\s*")[^"]+(")"#, "$1<redacted>$2")
        ]

        for (pattern, replacement) in redactionRules {
            redacted = redacted.replacingOccurrences(
                of: pattern,
                with: replacement,
                options: .regularExpression
            )
        }

        return redacted
    }

    private static func trimIfNeeded(_ value: String) -> String {
        #if DEBUG
        return value
        #else
        guard value.count > maxReleaseValueLength else { return value }
        return "\(value.prefix(maxReleaseValueLength))...<trimmed>"
        #endif
    }
}
