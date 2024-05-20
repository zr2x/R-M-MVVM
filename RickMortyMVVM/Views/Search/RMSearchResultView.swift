//
//  RMSearchResultView.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 19.05.2024.
//

import UIKit

/// Shows search results (table/collectionView as needed)
final class RMSearchResultView: UIView {

    private var viewModel: RMSearchResultViewModel? {
        didSet {
            processViewModel()
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.identifire)
        return tableView
    }()
    
//    private let collectionView: UICollectionView = {
//        let collectionView = UICollectionView()
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.isHidden = true
//        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.identifire)
//        collectionView.register(RMEpisodeInfoCollectionViewCell.self, forCellWithReuseIdentifier: RMEpisodeInfoCollectionViewCell.identifire)
//        return collectionView
//    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(tableView/*, collectionView*/)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
//            collectionView.topAnchor.constraint(equalTo: topAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        tableView.backgroundColor = .systemBlue
    }
    
    private func processViewModel() {
        guard let viewModel = viewModel else { return }
        
        switch viewModel {
        case .characters(let models):
            setupCollectionView()
        case .episodes(let models):
            setupCollectionView()
        case .locations(let models):
            setupTableView()
        }
    }

    private func setupCollectionView() {
        
    }   
    
    private func setupTableView() {
        tableView.isHidden = false
    }
    
    // MARK: - Public
    
    public func configure(wth viewModel: RMSearchResultViewModel) {
        self.viewModel = viewModel
    }
    
}
