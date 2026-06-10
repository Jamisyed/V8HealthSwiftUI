//
//  AppCoordinator.swift
//  V8HealthSwiftUI
//

import SwiftUI

@MainActor
@Observable
final class AppCoordinator: Coordinator {
    let id = UUID()
    var childCoordinators: [Coordinator] = []

    private let mainCoordinator = MainCoordinator()

    func start() {
        addChild(mainCoordinator)
        mainCoordinator.start()
    }

    var rootView: some View {
        MainCoordinatorRootView(coordinator: mainCoordinator)
    }
}
