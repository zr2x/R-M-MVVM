//
//  RMCollectionViewCell.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 29.04.2024.
//

import UIKit

/// Cell of a single character
final class RMCharacterCollectionViewCell: UICollectionViewCell {
    
    static let identifire = "RMCharacterCollectionViewCell"
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(imageView, nameLabel, statusLabel)
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            statusLabel.heightAnchor.constraint(equalToConstant: 40),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),

            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            nameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor, constant: -3),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -3),
            
        ])
    }
    
    public func configure(with viewModel: RMCharacterCollectionViewCellViewModel) {
        nameLabel.text = viewModel.characterName
        statusLabel.text = viewModel.characterStatusText
        viewModel.fetchImage { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [self] in
                    let image = UIImage(data: data)
                    self.imageView.image = image
                }
            case .failure(let error):
                break
            }
        }
    }
}
