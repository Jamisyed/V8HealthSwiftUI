//
//  AlarmListViewModel.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

@MainActor
@Observable
final class AlarmListViewModel: ResponseHandlingViewModel {
    var alarms: [AlarmClockItem] = []
    var statusMessage = ""
    var isEditing = false

    private let storageKey = "arrayClock"

    func onAppear() {
        subscribeToDevice()
        loadCachedAlarms()
        fetchFromDevice()
    }

    func onDisappear() {
        unsubscribeFromDevice()
    }

    func fetchFromDevice() {
        alarms.removeAll()
        send(BLECommand.getAlarms())
    }

    func deleteAll() {
        send(BLECommand.deleteAllAlarms())
        alarms.removeAll()
        saveCachedAlarms()
    }

    func delete(at offsets: IndexSet) {
        alarms.remove(atOffsets: offsets)
        saveToDevice()
    }

    func toggle(_ alarm: AlarmClockItem, enabled: Bool) {
        guard let index = alarms.firstIndex(where: { $0.id == alarm.id }) else { return }
        alarms[index].openOrClose = enabled
        saveToDevice()
    }

    func saveToDevice() {
        let payload = alarms.map { $0.toDictionary() }
        sendAll(BLECommand.setAlarms(payload))
        saveCachedAlarms()
    }

    func handleResponse(_ response: ParsedDeviceResponse) {
        switch response.dataType {
        case .getAlarmClock:
            if let items = response.dictionary["arrayAlarmClock"] as? [[String: Any]] {
                alarms.append(contentsOf: items.map(AlarmClockItem.fromDictionary))
            }
            if response.isEnd {
                saveCachedAlarms()
                statusMessage = "Alarms loaded"
            }
        case .setAlarmClock, .deleteAllAlarmClock:
            saveCachedAlarms()
            statusMessage = "Alarms updated"
        default:
            break
        }
    }

    private func loadCachedAlarms() {
        guard let cached = UserDefaults.standard.array(forKey: storageKey) as? [[String: Any]] else { return }
        alarms = cached.map(AlarmClockItem.fromDictionary)
    }

    private func saveCachedAlarms() {
        let payload = alarms.map { $0.toDictionary() }
        UserDefaults.standard.set(payload, forKey: storageKey)
    }
}
