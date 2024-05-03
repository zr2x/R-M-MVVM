//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 01.05.2024.
//

import UIKit

class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    static let identifire = "RMCharacterEpisodeCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .systemFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupConstraints() {
        
    }
    
    public func configure(with viewModel: RMCharacterEpisodeCollectionViewCellViewModel) {
        
    }
}
