//
//  OMDBClient.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import RxSwift
import Alamofire

class OMDBClient {
    private let session: Session
    private let baseURL: URL
    private let apiKey: String

    init(baseURL: URL, apiKey: String) {
        session = .default
        self.baseURL = baseURL
        self.apiKey = apiKey
    }
}

extension OMDBClient: MovieClient {
    func fetchMovies(with query: String, at page: Int) -> Single<[Movie]> {
        let request = OMDBSearchMoviesRequest(query: query, page: page)
        return send(request).map { $0.results ?? [] }
    }
    
    func fetchMovieDetail(with id: String) -> Single<Movie> {
        let request = OMDBFetchMovieDetailRequest(id: id)
        return send(request)
    }
}

private extension OMDBClient {
    func send<RequestType: OMDBRequest>(_ request: RequestType) -> Single<RequestType.Response> {
        guard request.method == .get else {
            fatalError("Invalid request method. Only `GET` method is supported at this time!")
        }

        var parameters = request.asParameters ?? [:]
        parameters["apikey"] = apiKey

        return Single.create { single in
            let request = self.session
                .request(self.baseURL, method: request.method, parameters: parameters, encoding: URLEncoding.default)
                .responseOMDBResponse { (result: Result<RequestType.Response, Error>) in
                    switch result {
                    case .success(let response):
                        single(.success(response))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

