//
//  RMCharacterViewController.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 27.04.2024.
//

import UIKit

final class RMCharacterViewController: UIViewController {
    
    private let characterListView = CharacterListView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        self.title = "Characters"
        
        view.addSubview(characterListView)

    }
    
    // MARK: - Setup view
    
    private func setupView() {
        NSLayoutConstraint.activate([
        
            characterListView.topAnchor.constraint(equalTo: view.topAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            characterListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            characterListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
