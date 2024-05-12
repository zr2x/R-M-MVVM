//
//  RMLocationDetailViewController.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 12.05.2024.
//

import UIKit

final class RMLocationDetailViewController: UIViewController {
    
    private let viewModel: RMLocationDetailViewViewModel
    private let detailView = RMLocationDetailView()
    
    // MARK: - Init
    init(location: RMLocation) {
        let url = URL(string: location.url)
        self.viewModel = .init(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.delegate = self
        detailView.delegate = self
        setupConstraints()
        viewModel.fetchLocationData()
    }
    
    private func setupView() {
        title = "Location"
        view.addSubview(detailView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        
        ])
    }
    
    // MARK: - Action
    
    @objc
    private func didTapShare() {
        
    }
}

//MARK: - RMLocationDetailViewViewModelDelegate

extension RMLocationDetailViewController: RMLocationDetailViewViewModelDelegate {
    func didFetchLocationDetails() {
        detailView.configure(with: viewModel)
    }
}

//MARK: - RMLocationDetailViewDelegate

extension RMLocationDetailViewController: RMLocationDetailViewDelegate {
    func rmEpisodeDetailView(_ detailView: RMLocationDetailView, didSelect character: RMCharacter) {
        let characterVC = RMCharacterDetailViewController(viewModel: .init(character: character))
        characterVC.title = character.name
        characterVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(characterVC, animated: true)
    }
}

