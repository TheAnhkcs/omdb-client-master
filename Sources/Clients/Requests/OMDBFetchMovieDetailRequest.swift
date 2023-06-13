//
//  OMDBFetchMovieDetailRequest.swift
//  OMDBClient
//
//  Created by duc on 14/07/2021.
//

import Alamofire

struct OMDBFetchMovieDetailRequest: OMDBRequest {
    typealias Response = Movie

    let method = HTTPMethod.get

    let id: String

    private enum CodingKeys: String, CodingKey {
        case id = "i"
    }
}
