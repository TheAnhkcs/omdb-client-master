//
//  DetailUseCase.swift
//  OMDBClient
//
//  Created by duc on 14/07/2021.
//

import RxSwift

protocol DetailUseCase {
    func fetchMovieDetail(with id: String) -> Observable<Movie>
}

final class DefaultDetailUseCase {
    private let movieService: MovieClient

    init(movieService: MovieClient) {
        self.movieService = movieService
    }
}

extension DefaultDetailUseCase: DetailUseCase {
    func fetchMovieDetail(with id: String) -> Observable<Movie> {
        return movieService.fetchMovieDetail(with: id).asObservable()
    }
}
