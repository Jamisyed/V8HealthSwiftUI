//
//  StepGoalViewModel.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

@MainActor
@Observable
final class StepGoalViewModel: ResponseHandlingViewModel {
    var stepGoal = 8000
    var statusMessage = ""

    func onAppear() {
        subscribeToDevice()
        loadFromDevice()
    }

    func onDisappear() {
        unsubscribeFromDevice()
    }

    func loadFromDevice() {
        send(BLECommand.getStepGoal())
    }

    func saveToDevice() {
        send(BLECommand.setStepGoal(stepGoal))
    }

    func handleResponse(_ response: ParsedDeviceResponse) {
        switch response.dataType {
        case .getDeviceGoal:
            stepGoal = SDKHelpers.intValue(response.dictionary["stepGoal"], default: 8000)
            statusMessage = "Step goal loaded"
        case .setDeviceGoal:
            statusMessage = "Step goal saved"
        default:
            break
        }
    }
}
