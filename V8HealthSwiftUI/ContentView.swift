//
//  ContentView.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

struct ContentView: View {
    @State private var appCoordinator = AppCoordinator()

    var body: some View {
        appCoordinator.rootView
            .onAppear { appCoordinator.start() }
    }
}

#Preview {
    ContentView()
}
