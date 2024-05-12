//
//  RMSearchViewController.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 07.05.2024.
//

import UIKit

/// Configurable controller to search
final class RMSearchViewController: UIViewController {
    
    private let searchView: RMSearchView
    private let viewModel: RMSearchViewViewModel
    
    struct Config {
        
        enum `Type` {
            case character
            case location
            case episodes
            
            
            var title: String {
                switch self {
                case .character:
                    return "Search characters"
                case .location:
                    return "Search locations"
                case .episodes:
                    return "Search episodes"
                }
            }
        }
        
        let type: `Type`
    }
    
    // MARK: - Init
    
    init(config: Config) {
        let viewModel = RMSearchViewViewModel(config: config)
        self.viewModel = viewModel
        self.searchView = RMSearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.config.type.title
        view.backgroundColor = .systemMint
        view.addSubview(searchView)
        setupConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapExecuteSearch))
    }
                                                            
    @objc
    private func didTapExecuteSearch() {
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
