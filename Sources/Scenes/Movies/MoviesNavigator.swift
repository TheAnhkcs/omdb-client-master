//
//  MoviesNavigator.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import UIKit

protocol MoviesNavigator {
    func toDetail(of movie: Movie)
}

final class DefaultMoviesNavigator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension DefaultMoviesNavigator: MoviesNavigator {
    func toDetail(of movie: Movie) {
        let useCase = DefaultDetailUseCase(movieService: OMDBClient.default)
        let viewModel = DetailViewModel(useCase: useCase, movie: movie)
        let detailViewController = DetailViewController(viewModel: viewModel)
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
