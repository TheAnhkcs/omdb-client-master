//
//  OMDBRequest.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import Alamofire

//typealias OMDBResponse = Decodable  

protocol OMDBRequest: Encodable {
    associatedtype Response: Decodable

    var method: HTTPMethod { get }
}

