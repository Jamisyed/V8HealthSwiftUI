//
//  FavoriteConfigurator.swift
//  iOSCodingChallenge
//
//  Created by Syed M Abdul Rehman on 06/05/2026.
//

import UIKit

final class FavoriteConfigurator: Configurator {
    struct Dependencies {}

    func create(dependencies: Dependencies) -> UIViewController {
        let sessionStore: UserSessionStoring = UserSessionManager()
        let postRepository = PostRepositoryImpl(
            remoteDataSource: PostRemoteDataSource(networkClient: AlamofireNetworkClient()),
            localDataSource: PostLocalDataSource(
                realmProvider: RealmProvider(),
                sessionStore: sessionStore
            )
        )
        let observeFavoritesUseCase: ObserveFavoritePostsUseCaseType = ObserveFavoritePostsUseCase(
            postRepository: postRepository
        )
        let removeFavoriteUseCase: RemoveFavoritePostUseCaseType = RemoveFavoritePostUseCase(
            postRepository: postRepository
        )
        let viewModel = FavoriteViewModel(
            observeFavoritesUseCase: observeFavoritesUseCase,
            removeFavoriteUseCase: removeFavoriteUseCase
        )
        let viewController = FavoriteViewController(nibName: FavoriteViewController.nibName, bundle: nil)
        viewController.inject(viewModel: viewModel)

        let tabItem = MainTabItem.favourites
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(
            title: tabItem.title,
            image: UIImage(systemName: tabItem.imageName),
            selectedImage: UIImage(systemName: tabItem.selectedImageName)
        )
        return navigationController
    }
}

