//
//  RMCharacterInfoCollectionViewCell.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 01.05.2024.
//

import UIKit

class RMCharacterInfoCollectionViewCell: UICollectionViewCell {
    static let identifire = "RMCharacterInfoCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setupConstraints() {
        
    }
    
    public func configure(with viewModel: RMCharacterInfoCollectionViewCellViewModel) {
        
    }
}
