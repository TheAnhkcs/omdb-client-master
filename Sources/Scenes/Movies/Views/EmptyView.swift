//
//  EmptyView.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import UIKit
import SnapKit

class EmptyView: UIView {
    enum State {
        case welcome
        case empty
        case error
        case hidden
    }
    
    var state: State! {
        didSet {
            updateContent()
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.5)
            make.leading.equalToSuperview().offset(Constants.Movies.spacing)
            make.trailing.equalToSuperview().offset(-Constants.Movies.spacing)
        }
        
        state = .welcome
    }
    
    private func updateContent() {
        switch state {
        case .welcome:
            titleLabel.text = Constants.String.welcome
        case .empty:
            titleLabel.text = Constants.String.empty
        case .error:
            titleLabel.text = Constants.String.errorOccurred
        case .hidden:
            titleLabel.text = nil
        default:
            fatalError("State was not handled")
        }
        
        isHidden = state == .hidden
    }
}
