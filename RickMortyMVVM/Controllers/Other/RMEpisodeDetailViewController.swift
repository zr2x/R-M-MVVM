//
//  RMEpisodeDetailViewController.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 05.05.2024.
//

import UIKit

/// ViewController to show about single episode
final class RMEpisodeDetailViewController: UIViewController {
    
    private let url: URL?
    
    // MARK: - Init
    init(url: URL?) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        view.backgroundColor = .systemCyan
    }

}
