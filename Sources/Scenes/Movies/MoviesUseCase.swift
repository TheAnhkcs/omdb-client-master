//
//  MoviesUseCase.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import RxSwift

protocol MoviesUseCase {
    func fetchMovies(with query: String, at page: Int) -> Observable<[Movie]>
    func isValidQuery(_ query: String) -> Bool
}

final class DefaultMoviesUseCase {
    private let movieService: MovieClient
    
    init(movieService: MovieClient) {
        self.movieService = movieService
    }
}

extension DefaultMoviesUseCase: MoviesUseCase {
    func isValidQuery(_ query: String) -> Bool {
        query.count >= 3
    }
    
    func fetchMovies(with query: String, at page: Int) -> Observable<[Movie]> {
        movieService.fetchMovies(with: query, at: page).asObservable()
    }
}
