//
//  MainCoordinator.swift
//  iOSCodingChallenge
//
//  Created by Syed M Abdul Rehman on 06/05/2026.
//

import UIKit

protocol MainFlowCoordinating: AnyObject {
    func didRequestLogout()
}

final class MainCoordinator: Coordinator {
    let id = UUID()
    var childCoordinators: [Coordinator] = []
    weak var delegate: MainCoordinatorDelegate?

    private let window: UIWindow
    private let postConfigurator = PostConfigurator()
    private let favoriteConfigurator = FavoriteConfigurator()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let tabbar = TabbarViewController(nibName: TabbarViewController.nibName, bundle: nil)

        let postViewController = postConfigurator.create(
            dependencies: .init(
                coordinator: self
            )
        )
        let favoriteViewController = favoriteConfigurator.create(
            dependencies: .init()
        )

        tabbar.setViewControllers([postViewController, favoriteViewController], animated: false)
        window.rootViewController = tabbar
        window.makeKeyAndVisible()
    }
}

extension MainCoordinator: MainFlowCoordinating {
    func didRequestLogout() {
        delegate?.mainCoordinatorDidRequestLogout(self)
    }
}

