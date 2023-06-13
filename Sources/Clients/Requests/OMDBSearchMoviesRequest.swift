//
//  OMDBSearchMoviesRequest.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import Alamofire

struct OMDBSearchMoviesRequest: OMDBRequest {
    struct Response: Decodable {
        let results: [Movie]?
        
        private enum CodingKeys: String, CodingKey {
            case results = "Search"
        }
    }

    let method = HTTPMethod.get

    let query: String
    let page: Int
    let type = "movie"

    private enum CodingKeys: String, CodingKey {
        case page
        case query = "s"
        case type
    }
}
