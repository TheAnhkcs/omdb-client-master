//
//  UIImageExtensions.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import Nuke

extension UIImageView {
    func loadImage(with url: URL, placeholder: UIImage?) {
        let options = ImageLoadingOptions(
            placeholder: placeholder,
            transition: .fadeIn(duration: 0.25)
        )
        Nuke.loadImage(with: url, options: options, into: self)
    }
}
