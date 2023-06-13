//
//  LoadMoreCell.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import UIKit

class LoadMoreCell: UICollectionViewCell {
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.style = .medium
        indicatorView.color = .gray
        return indicatorView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        loadingIndicator.center = contentView.center
        if !loadingIndicator.isAnimating {
            loadingIndicator.startAnimating()
        }
    }

    private func setupSubviews() {
        contentView.addSubview(loadingIndicator)
    }
}
