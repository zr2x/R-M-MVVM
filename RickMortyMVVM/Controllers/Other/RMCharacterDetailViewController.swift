//
//  RMCharacterDetailViewController.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 29.04.2024.
//

import UIKit

/// Controller showing info about single character
final class RMCharacterDetailViewController: UIViewController {
   
    private let viewModel: RMCharacterDetailViewViewModel

    private let detailView: RMCharacterDetailView
    
    // MARK: init
    init(viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        self.detailView = RMCharacterDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
        setupViews()
        setupConstraints()
        
        detailView.collectionView?.delegate = self
        detailView.collectionView?.dataSource = self
    }
    
    private func setupViews() {
        view.addSubview(detailView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    @objc 
    private func didTapShare() {
        
    }
}

    // MARK: - CollectionView 

extension RMCharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .photo:
            return 1
        case .information(let viewModels):
            return viewModels.count
        case .episodes(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .photo(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterPhotoCollectionViewCell.identifire, 
                                                                for: indexPath) as? RMCharacterPhotoCollectionViewCell else {
                return UICollectionViewCell() }
            cell.configure(with: viewModel)
            return cell
        case .information(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterInfoCollectionViewCell.identifire,
                                                                for: indexPath) as? RMCharacterInfoCollectionViewCell else {
                return UICollectionViewCell() }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .episodes(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifire, 
                                                                for: indexPath) as? RMCharacterEpisodeCollectionViewCell else {
                return UICollectionViewCell() }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
    }  
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .photo, .information:
            break
        case .episodes:
            let episodes = self.viewModel.episodes
            let selection = episodes[indexPath.row]
            let episodeVC = RMEpisodeDetailViewController(url: URL(string: selection))
            navigationController?.pushViewController(episodeVC, animated: true)
        }
    }
}
