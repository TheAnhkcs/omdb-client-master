//
//  UICollectionViewExtensions.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import UIKit

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(of type: T.Type = T.self,
                                                      indexPath: IndexPath) -> T? {
        let cell = dequeueReusableCell(
            withReuseIdentifier: NSStringFromClass(type.self),
            for: indexPath) as? T

        return cell
    }

    func register<T: UICollectionViewCell>(of type: T.Type = T.self) {
        register(type.self,
                 forCellWithReuseIdentifier: NSStringFromClass(type.self))
    }
}
