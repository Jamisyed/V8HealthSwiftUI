//
//  PersonalInfoViewModel.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import Foundation

@MainActor
@Observable
final class PersonalInfoViewModel: ResponseHandlingViewModel {
    var info = PersonalInfoModel()
    var statusMessage = ""

    func onAppear() {
        subscribeToDevice()
        loadFromDevice()
    }

    func onDisappear() {
        unsubscribeFromDevice()
    }

    func loadFromDevice() {
        send(BLECommand.getPersonalInfo())
    }

    func saveToDevice() {
        send(BLECommand.setPersonalInfo(SDKHelpers.personalInfo(from: info)))
    }

    func handleResponse(_ response: ParsedDeviceResponse) {
        switch response.dataType {
        case .getPersonalInfo:
            info = PersonalInfoModel(
                gender: SDKHelpers.intValue(response.dictionary["gender"], default: 1),
                age: SDKHelpers.intValue(response.dictionary["age"], default: 30),
                height: SDKHelpers.intValue(response.dictionary["height"], default: 170),
                weight: SDKHelpers.intValue(response.dictionary["weight"], default: 70),
                stride: SDKHelpers.intValue(response.dictionary["stride"], default: 75)
            )
            statusMessage = "Personal info loaded"
        case .setPersonalInfo:
            statusMessage = "Personal info saved"
        default:
            break
        }
    }
}
