//
//  AppCoordinator.swift
//  iOSCodingChallenge
//
//  Created by Syed M Abdul Rehman on 06/05/2026.
//

import UIKit

protocol AuthCoordinatorDelegate: AnyObject {
    func authCoordinatorDidFinish(_ coordinator: AuthCoordinator)
}

protocol MainCoordinatorDelegate: AnyObject {
    func mainCoordinatorDidRequestLogout(_ coordinator: MainCoordinator)
}

final class AppCoordinator: Coordinator {
    let id = UUID()
    var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow
    private let navigationController = UINavigationController()
    private let sessionStore: UserSessionStoring
    
    init(
        window: UIWindow,
        sessionStore: UserSessionStoring = UserSessionManager()
    ) {
        self.window = window
        self.sessionStore = sessionStore
    }
    
    func start() {
        if sessionStore.currentUser != nil {
            startMainFlow()
        } else {
            startAuthFlow()
        }
    }
    
    private func startAuthFlow() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let coordinator = AuthCoordinator(
            navigationController: navigationController
        )
        coordinator.delegate = self
        addChild(coordinator)
        coordinator.start()
    }
    
    private func startMainFlow() {
        let coordinator = MainCoordinator(window: window)
        coordinator.delegate = self
        addChild(coordinator)
        coordinator.start()
    }
}

extension AppCoordinator: AuthCoordinatorDelegate {
    func authCoordinatorDidFinish(_ coordinator: AuthCoordinator) {
        removeChild(coordinator)
        startMainFlow()
    }
}

extension AppCoordinator: MainCoordinatorDelegate {
    func mainCoordinatorDidRequestLogout(_ coordinator: MainCoordinator) {
        sessionStore.clear()
        removeChild(coordinator)
        startAuthFlow()
    }
}

