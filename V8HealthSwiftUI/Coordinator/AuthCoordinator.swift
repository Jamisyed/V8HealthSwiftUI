//
//  AuthCoordinator.swift
//  iOSCodingChallenge
//
//  Created by Syed M Abdul Rehman on 06/05/2026.
//

import UIKit

protocol LoginFlowCoordinating: AnyObject {
    func didLoginSuccessfully()
}

final class AuthCoordinator: Coordinator {
    let id = UUID()
    var childCoordinators: [Coordinator] = []
    weak var delegate: AuthCoordinatorDelegate?

    private let navigationController: UINavigationController
    private let loginConfigurator = LoginConfigurator()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let loginViewController = loginConfigurator.create(
            dependencies: .init()
        )
        (loginViewController as? LoginViewController)?.coordinator = self
        navigationController.setViewControllers([loginViewController], animated: false)
    }
}

extension AuthCoordinator: LoginFlowCoordinating {
    func didLoginSuccessfully() {
        delegate?.authCoordinatorDidFinish(self)
    }
}

