//
//  RMSearchViewController.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 07.05.2024.
//

import UIKit

/// Configurable controller to search
final class RMSearchViewController: UIViewController {
    let config: Config

    struct Config {
        
        enum `Type` {
            case character
            case location
            case episodes
        }
        
        let type: `Type`
    }
    
    // MARK: - Init
    
    init(config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemMint
    }
}
