//
//  MovieClient.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import RxSwift

protocol MovieClient {
    func fetchMovies(with query: String, at page: Int) -> Single<[Movie]>
    func fetchMovieDetail(with id: String) -> Single<Movie>
}
