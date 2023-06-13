//
//  MovieCell.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import UIKit
import SnapKit

class MovieCell: UICollectionViewCell {
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = Constants.Image.thumbnailPlaceholder.image
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.bottom.trailing.equalToSuperview().offset(-4)
        }
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        
        guard let poster = movie.poster, let posterURL = URL(string: poster) else {
            return
        }
        thumbnailImageView.loadImage(
            with: posterURL,
            placeholder: Constants.Image.thumbnailPlaceholder.image
        )
    }
    
    override func prepareForReuse() {
        thumbnailImageView.image = Constants.Image.thumbnailPlaceholder.image
    }
}
