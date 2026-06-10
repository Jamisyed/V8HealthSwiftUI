//
//  V8HealthSwiftUIApp.swift
//  V8HealthSwiftUI
//
//  Created by Syed M Abdul Rehman on 6/8/26.
//

import SwiftUI

@main
struct V8HealthSwiftUIApp: App {
    @State private var appCoordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            appCoordinator.rootView
                .onAppear { appCoordinator.start() }
        }
    }
}
