//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 01.05.2024.
//

import UIKit

class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    static let identifire = "RMCharacterEpisodeCollectionViewCell"
    
    private let seasonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let airDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()

    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        seasonLabel.text = nil
        nameLabel.text = nil
        airDateLabel.text = nil
    }
    
    private func setupViews() {
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .systemFill
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
        contentView.layer.borderWidth = 2
        contentView.addSubviews(seasonLabel, nameLabel, airDateLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            seasonLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            seasonLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            seasonLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            seasonLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            
            nameLabel.topAnchor.constraint(equalTo: seasonLabel.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -8),
            seasonLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            
            airDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            airDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            airDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            airDateLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
        ])
    }
    
    public func configure(with viewModel: RMCharacterEpisodeCollectionViewCellViewModel) {
        viewModel.registerForData { [weak self] data in
            DispatchQueue.main.async {
                guard let self else { return }
                self.seasonLabel.text = "Episode: \(data.episode)"
                self.nameLabel.text = data.name
                self.airDateLabel.text = "Air date: \(data.airDate)"
            }
        }
        viewModel.fetchEpisode()
    }
}
