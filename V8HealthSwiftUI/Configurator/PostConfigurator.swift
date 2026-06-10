//
//  PostConfigurator.swift
//  iOSCodingChallenge
//
//  Created by Syed M Abdul Rehman on 06/05/2026.
//

import UIKit

final class PostConfigurator: Configurator {
    struct Dependencies {
        weak var coordinator: MainFlowCoordinating?
    }

    func create(dependencies: Dependencies) -> UIViewController {
        let sessionStore: UserSessionStoring = UserSessionManager()
        let postRepository = PostRepositoryImpl(
            remoteDataSource: PostRemoteDataSource(networkClient: AlamofireNetworkClient()),
            localDataSource: PostLocalDataSource(
                realmProvider: RealmProvider(),
                sessionStore: sessionStore
            )
        )
        let fetchPostsUseCase: FetchPostsUseCaseType = FetchPostsUseCase(postRepository: postRepository)
        let toggleFavoriteUseCase: ToggleFavoritePostUseCaseType = ToggleFavoritePostUseCase(
            postRepository: postRepository
        )
        let viewModel = PostViewModel(
            fetchPostsUseCase: fetchPostsUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase
        )
        let viewController = PostViewController(nibName: PostViewController.nibName, bundle: nil)
        viewController.inject(
            viewModel: viewModel,
            coordinator: dependencies.coordinator
        )

        let tabItem = MainTabItem.posts
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(
            title: tabItem.title,
            image: UIImage(systemName: tabItem.imageName),
            selectedImage: UIImage(systemName: tabItem.selectedImageName)
        )
        return navigationController
    }
}

