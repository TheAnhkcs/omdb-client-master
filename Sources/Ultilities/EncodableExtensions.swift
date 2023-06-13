//
//  EncodableExtensions.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import Alamofire

extension Encodable where Self: OMDBRequest {
    var asData: Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .millisecondsSince1970
        return (try? encoder.encode(self)) ?? Data()
    }

    var asParameters: Parameters? {
        guard let dictionary =
            try? JSONSerialization.jsonObject(with: asData, options: .allowFragments) as? [String: Any] else {
            return nil
        }
        
        print("dictionary: \(dictionary)")
        return dictionary
    }
}
