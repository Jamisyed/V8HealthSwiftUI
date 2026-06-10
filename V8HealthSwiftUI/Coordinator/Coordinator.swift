//
//  Coordinator.swift
//  V8HealthSwiftUI
//

import Foundation

protocol Coordinator: AnyObject {
    var id: UUID { get }
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0.id == coordinator.id }
    }
}
