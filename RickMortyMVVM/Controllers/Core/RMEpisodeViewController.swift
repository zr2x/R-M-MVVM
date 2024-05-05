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

        view.backgroundColor = .systemBackground
        self.title = "Episodes"
        setupView()
    }
    
    // MARK: - Setup view
    
    private func setupView() {
        episodeListView.delegate = self
        view.addSubview(episodeListView)
        NSLayoutConstraint.activate([
        
            episodeListView.topAnchor.constraint(equalTo: view.topAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            episodeListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            episodeListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
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
