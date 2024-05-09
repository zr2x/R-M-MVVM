//
//  RMEpisodeInfoCollectionViewCell.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 09.05.2024.
//

import UIKit

final class RMEpisodeInfoCollectionViewCell: UICollectionViewCell {

    static let identifire = "RMEpisodeInfoCollectionViewCell"
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        setupLayer()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    // MARK: - Private
    
    private func setupLayer() {
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
    private func setupConstraints() {
        
    }
    
    // MARK: - Public
    public func configure(with viewModel: RMEpisodeInfoCollectionViewCellViewModel) {
    }
}
