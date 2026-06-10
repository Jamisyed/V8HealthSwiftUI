//
//  AlarmListView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct AlarmListView: View {
    @State private var viewModel = AlarmListViewModel()
    @State private var showAddAlarm = false
    private let ble = V8BLEClient.shared

    var body: some View {
        List {
            if viewModel.alarms.isEmpty {
                ContentUnavailableView("No Alarms", systemImage: "alarm", description: Text("Add an alarm to get started."))
            } else {
                ForEach(viewModel.alarms) { alarm in
                    NavigationLink {
                        AlarmEditView(
                            alarm: alarm,
                            isNew: false,
                            onSave: { updated in
                                if let index = viewModel.alarms.firstIndex(where: { $0.id == updated.id }) {
                                    viewModel.alarms[index] = updated
                                    viewModel.saveToDevice()
                                }
                            }
                        )
                    } label: {
                        AlarmRow(alarm: alarm)
                    }
                }
                .onDelete { viewModel.delete(at: $0) }
            }
        }
        .navigationTitle("Alarms")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Delete All", role: .destructive) {
                    viewModel.deleteAll()
                }
                .disabled(viewModel.alarms.isEmpty)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add") {
                    showAddAlarm = true
                }
                .disabled(viewModel.alarms.count >= 10)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Refresh") { viewModel.fetchFromDevice() }
            }
        }
        .sheet(isPresented: $showAddAlarm) {
            NavigationStack {
                AlarmEditView(
                    alarm: AlarmClockItem(),
                    isNew: true,
                    onSave: { alarm in
                        viewModel.alarms.append(alarm)
                        viewModel.saveToDevice()
                        showAddAlarm = false
                    }
                )
            }
        }
        .requiresConnection(ble.isReady)
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .trackLife()
    }
}

private struct AlarmRow: View {
    let alarm: AlarmClockItem

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(String(format: "%02d:%02d", alarm.hour, alarm.minute))
                    .font(.title3.monospacedDigit())
                Text(alarm.label.isEmpty ? alarmTypeName : alarm.label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(alarm.openOrClose ? "On" : "Off")
                .foregroundStyle(alarm.openOrClose ? .green : .secondary)
        }
    }

    private var alarmTypeName: String {
        switch alarm.clockType {
        case 2: return "Medication"
        case 3: return "Water"
        case 4: return "Meal"
        default: return "General"
        }
    }
}
