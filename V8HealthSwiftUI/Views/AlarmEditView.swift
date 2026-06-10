//
//  AlarmEditView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct AlarmEditView: View {
    @State private var alarm: AlarmClockItem
    let isNew: Bool
    let onSave: (AlarmClockItem) -> Void
    @Environment(\.dismiss) private var dismiss

    init(alarm: AlarmClockItem, isNew: Bool, onSave: @escaping (AlarmClockItem) -> Void) {
        _alarm = State(initialValue: alarm)
        self.isNew = isNew
        self.onSave = onSave
    }

    private var selectedWeekdays: Binding<Set<Int>> {
        Binding(
            get: { Set((0..<7).filter { alarm.weekBitmask & (1 << $0) != 0 }) },
            set: { alarm.weekBitmask = $0.reduce(0) { $0 | (1 << $1) } }
        )
    }

    var body: some View {
        Form {
            Toggle("Enabled", isOn: $alarm.openOrClose)

            DatePicker(
                "Time",
                selection: Binding(
                    get: {
                        Calendar.current.date(
                            from: DateComponents(hour: alarm.hour, minute: alarm.minute)
                        ) ?? Date()
                    },
                    set: { date in
                        alarm.hour = Calendar.current.component(.hour, from: date)
                        alarm.minute = Calendar.current.component(.minute, from: date)
                    }
                ),
                displayedComponents: .hourAndMinute
            )

            Picker("Type", selection: $alarm.clockType) {
                Text("General").tag(1)
                Text("Medication").tag(2)
                Text("Water").tag(3)
                Text("Meal").tag(4)
            }

            TextField("Label", text: $alarm.label)

            Section("Repeat") {
                WeekdayPickerView(selectedDays: selectedWeekdays)
            }
        }
        .navigationTitle(isNew ? "New Alarm" : "Edit Alarm")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    onSave(alarm)
                    dismiss()
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
        }
        .trackLife()
    }
}
