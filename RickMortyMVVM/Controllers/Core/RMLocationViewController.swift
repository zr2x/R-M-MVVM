//
//  RMLocationViewController.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 27.04.2024.
//

import UIKit

final class RMLocationViewController: UIViewController {
    
    private let primaryView = RMLocationView()
    private let viewModel = RMLocationViewViewModel()

    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        self.title = "Locations"
        view.addSubviews(primaryView)
        setupConstraints()
        addSearchButton()
        viewModel.delegate = self
        primaryView.delegate = self
        viewModel.fetchLocation()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            primaryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc
    private func didTapSearch() {
        let searchVC = RMSearchViewController(config: .init(type: .location))
        searchVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(searchVC, animated: true)
        
    }
}

    // MARK: - RMLocationViewViewModelDelegate

extension RMLocationViewController: RMLocationViewViewModelDelegate {
    func didFetchInitialLocations() {
        primaryView.configure(with: viewModel)
    }
}

    // MARK: - RMLocationViewDelegate
extension RMLocationViewController: RMLocationViewDelegate {
    func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocation) {
        let locationVC = RMLocationDetailViewController(location: location)
        locationVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(locationVC, animated: true)
    }
}
