//
//  ContentView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct ContentView: View {
    @Bindable private var ble = V8BLEClient.shared
    @State private var showScanner = false

    var body: some View {
        NavigationStack {
            DashboardView(showScanner: $showScanner)
                .navigationTitle("V8 Health")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(ble.connection.isConnected ? "Disconnect" : "Scan") {
                            if ble.connection.isConnected {
                                ble.disconnect()
                            } else {
                                showScanner = true
                                ble.startScan()
                            }
                        }
                    }
                }
                .sheet(isPresented: $showScanner) {
                    DeviceScanView()
                }
        }
        .deviceEventAlerts()
        .trackLife()
    }
}

#Preview {
    ContentView()
}
