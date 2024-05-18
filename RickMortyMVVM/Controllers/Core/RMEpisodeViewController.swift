//
//  RMEpisodeViewController.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 27.04.2024.
//

import UIKit

final class RMEpisodeViewController: UIViewController {
    private let episodeListView = RMEpisodeListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        episodeListView.delegate = self
        setupConstraints()
        addSearchButton()
    }
    
    // MARK: - Setup view
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        self.title = "Episodes"
        view.addSubview(episodeListView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
        
            episodeListView.topAnchor.constraint(equalTo: view.topAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            episodeListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            episodeListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc
    private func didTapSearch() {
        let searchVC = RMSearchViewController(config: .init(type: .episode))
        searchVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(searchVC, animated: true)
    }
}

// MARK: RMEpisodeListViewDelegate

extension RMEpisodeViewController: RMEpisodeListViewDelegate {
    func rmEpisodeListView(_ episodeListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode) {
        let episodeVC = RMEpisodeDetailViewController(url: URL(string: episode.url))
        episodeVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(episodeVC, animated: true)
    }
}
