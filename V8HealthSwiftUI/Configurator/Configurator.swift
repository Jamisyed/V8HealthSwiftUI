//
//  Configurator.swift
//  iOSCodingChallenge
//
//  Created by Syed M Abdul Rehman on 06/05/2026.
//

import UIKit

protocol Configurator {
    associatedtype Dependencies
    func create(dependencies: Dependencies) -> UIViewController
}

