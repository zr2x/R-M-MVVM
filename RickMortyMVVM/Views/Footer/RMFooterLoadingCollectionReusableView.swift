//
//  RMFooterLoadingCollectionReusableView.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 29.04.2024.
//

import UIKit

final class RMFooterLoadingCollectionReusableView: UICollectionReusableView {
    static let identifire = "RMFooterLoadingCollectionReusableView"
    
    private let spiner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews(spiner)
        setupConstraints()
        startAnimating()
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            spiner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spiner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spiner.heightAnchor.constraint(equalToConstant: 100),
            spiner.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    public func startAnimating() {
        spiner.startAnimating()
    }
}
