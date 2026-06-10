//
//  LoginConfigurator.swift
//  iOSCodingChallenge
//
//  Created by Syed M Abdul Rehman on 06/05/2026.
//

import UIKit

final class LoginConfigurator: Configurator {
    struct Dependencies {}

    func create(dependencies: Dependencies) -> UIViewController {
        let loginFormValidator: LoginFormValidating = LoginFormValidator()
        let authRepository: AuthRepository = MockAuthRepository()
        let sessionStore: UserSessionStoring = UserSessionManager()
        let loginUseCase: LoginUseCaseType = LoginUseCase(
            authRepository: authRepository,
            sessionStore: sessionStore
        )
        let viewModel = LoginViewModel(
            formValidator: loginFormValidator,
            loginUseCase: loginUseCase
        )

        let viewController = LoginViewController(nibName: LoginViewController.nibName, bundle: nil)
        viewController.inject(viewModel: viewModel)
        return viewController
    }
}

