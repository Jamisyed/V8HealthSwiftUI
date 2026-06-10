//
//  LogExportViewModel.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

@MainActor
@Observable
final class LogExportViewModel {
    static let fileName = "Ble SDK Demo.txt"

    var fileExists = false
    var fileSizeText = "—"
    var statusMessage = ""

    var fileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(Self.fileName)
    }

    func refresh() {
        let path = fileURL.path
        fileExists = FileManager.default.fileExists(atPath: path)
        guard fileExists,
              let attributes = try? FileManager.default.attributesOfItem(atPath: path),
              let size = attributes[.size] as? NSNumber else {
            fileSizeText = "—"
            return
        }
        fileSizeText = ByteCountFormatter.string(fromByteCount: size.int64Value, countStyle: .file)
    }

    func ensureLogFile() {
        guard !fileExists else { return }
        let content = "V8 BLE SDK Demo Log\nCreated: \(Date())\n"
        try? content.write(to: fileURL, atomically: true, encoding: .utf8)
        refresh()
    }

    func deleteLog() {
        try? FileManager.default.removeItem(at: fileURL)
        statusMessage = "Log deleted"
        refresh()
    }
}
