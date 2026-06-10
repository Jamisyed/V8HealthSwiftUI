//
//  PersonalInfoView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct PersonalInfoView: View {
    @State private var viewModel = PersonalInfoViewModel()
    private let ble = V8BLEClient.shared

    var body: some View {
        Form {
            Picker("Gender", selection: $viewModel.info.gender) {
                Text("Female").tag(0)
                Text("Male").tag(1)
            }
            Stepper("Age: \(viewModel.info.age)", value: $viewModel.info.age, in: 5...100)
            Stepper("Height: \(viewModel.info.height) cm", value: $viewModel.info.height, in: 50...250)
            Stepper("Weight: \(viewModel.info.weight) kg", value: $viewModel.info.weight, in: 30...200)
            Stepper("Stride: \(viewModel.info.stride) cm", value: $viewModel.info.stride, in: 30...120)

            Section {
                Button("Load from Device") { viewModel.loadFromDevice() }
                Button("Save to Device") { viewModel.saveToDevice() }
            }

            if !viewModel.statusMessage.isEmpty {
                Text(viewModel.statusMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Personal Info")
        .requiresConnection(ble.isReady)
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .trackLife()
    }
}
