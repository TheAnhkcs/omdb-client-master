//
//  AppController.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import UIKit

struct AppController {
    func attachInitialUI(with window: UIWindow?) {
        guard let window = window else { return }

        window.rootViewController = makeRootViewController()
        window.makeKeyAndVisible()
    }
}

private extension AppController {
    func makeRootViewController() -> UIViewController {
        let navigationController = UINavigationController(nibName: nil, bundle: nil)
        let useCase = DefaultMoviesUseCase(movieService: OMDBClient.default)
        let navigator = DefaultMoviesNavigator(navigationController: navigationController)
        let viewModel = MoviesViewModel(useCase: useCase, navigator: navigator)
        let viewController = MoviesViewController(viewModel: viewModel)
        navigationController.viewControllers = [viewController]
        return navigationController
    }
}

extension OMDBClient {
    static let `default` = OMDBClient(
        baseURL: URL(string: Constants.OMDBClient.basePath)!,
        apiKey: Constants.OMDBClient.apiKey
    )
}
