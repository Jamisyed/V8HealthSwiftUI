//
//  ActivityModeViewModel.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

struct SportType: Identifiable, Hashable {
    let id: Int
    let name: String
}

@MainActor
@Observable
final class ActivityModeViewModel: ResponseHandlingViewModel {
    static let sportTypes: [SportType] = [
        SportType(id: 0, name: "Run"), SportType(id: 1, name: "Cycling"),
        SportType(id: 9, name: "Walk"), SportType(id: 2, name: "Badminton"),
        SportType(id: 3, name: "Football"), SportType(id: 4, name: "Tennis"),
        SportType(id: 6, name: "Breath"), SportType(id: 7, name: "Dance"),
        SportType(id: 8, name: "Basketball"), SportType(id: 10, name: "Workout"),
        SportType(id: 11, name: "Cricket"), SportType(id: 12, name: "Hiking"),
        SportType(id: 13, name: "Aerobics"), SportType(id: 14, name: "Ping Pong"),
        SportType(id: 15, name: "Rope Jump"), SportType(id: 16, name: "Sit Ups"),
        SportType(id: 17, name: "Volleyball"),
    ]

    var selectedSport = sportTypes[0]
    var metrics = ActivityModeMetrics()
    var statusMessage = ""
    var isActive = false

    func onAppear() {
        subscribeToDevice()
    }

    func onDisappear() {
        unsubscribeFromDevice()
    }

    func start() {
        sendActivity(workMode: .startActivity)
        isActive = true
    }

    func pause() {
        sendActivity(workMode: .pauseActivity)
    }

    func resume() {
        sendActivity(workMode: .continueActivity)
    }

    func stop() {
        sendActivity(workMode: .stopActivity)
        isActive = false
    }

    func handleResponse(_ response: ParsedDeviceResponse) {
        switch response.dataType {
        case .startActivityMode:
            statusMessage = "Activity started"
        case .pauseActivityMode:
            statusMessage = "Activity paused"
        case .continueActivityMode:
            statusMessage = "Activity resumed"
        case .stopActivityMode:
            statusMessage = "Activity stopped"
            isActive = false
        case .deviceSendDataToApp:
            metrics = ActivityModeMetrics(
                steps: SDKHelpers.stringValue(response.dictionary["step"]),
                heartRate: SDKHelpers.stringValue(response.dictionary["heartRate"]),
                calories: SDKHelpers.stringValue(response.dictionary["calories"]),
                activeMinutes: SDKHelpers.stringValue(response.dictionary["activeMinutes"])
            )
        default:
            break
        }
    }

    private func sendActivity(workMode: WORKMODE_V8) {
        var breath = MyBreathParameter_V8()
        breath.breathMode = 0
        breath.DurationOfBreathingExercise = 0
        let mode = ACTIVITYMODE_V8(rawValue: selectedSport.id) ?? .Run
        send(BLECommand.startActivity(mode: mode, workMode: workMode, minutes: 30, breath: breath))
    }
}
