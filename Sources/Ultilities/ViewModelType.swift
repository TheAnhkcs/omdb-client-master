//
//  ViewModelType.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
