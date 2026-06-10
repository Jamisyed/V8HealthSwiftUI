//
//  HistorySyncHelper.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

@MainActor
final class HistorySyncHelper {
    private(set) var batchCount = 0
    var isSyncing = false

    func beginSync() {
        batchCount = 0
        isSyncing = true
    }

    func finishSync() {
        batchCount = 0
        isSyncing = false
    }

    func recordBatch(isEnd: Bool) -> Bool {
        batchCount += 1
        if isEnd {
            finishSync()
            return false
        }
        return batchCount >= 50
    }
}
