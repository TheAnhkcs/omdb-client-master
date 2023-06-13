//
//  DataRequestExtensions.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import Alamofire

extension DataRequest {
    func responseOMDBResponse<ResponseType: Decodable>(
        completion: @escaping (Result<ResponseType, Error>) -> Void) -> Self {
        return responseData { completion(Self.validateResult($0)) }
    }

    private static func validateResult<ResponseType: Decodable>(_ response: AFDataResponse<Data>) -> Result<ResponseType, Error> {
        switch response.result {
        case .success(let data):
            do {
                let output = try JSONDecoder().decode(ResponseType.self, from: data)
                return .success(output)
            } catch {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
