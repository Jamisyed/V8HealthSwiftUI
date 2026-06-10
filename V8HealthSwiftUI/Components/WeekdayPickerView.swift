//
//  WeekdayPickerView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct WeekdayPickerView: View {
    @Binding var selectedDays: Set<Int>

    private let labels = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        HStack {
            ForEach(0..<7, id: \.self) { day in
                let isSelected = selectedDays.contains(day)
                Button(labels[day]) {
                    if isSelected {
                        selectedDays.remove(day)
                    } else {
                        selectedDays.insert(day)
                    }
                }
                .buttonStyle(.bordered)
                .tint(isSelected ? .accentColor : .gray)
            }
        }
    }
}
