//
//  RMSettingsViewController.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 27.04.2024.
//

import UIKit
import SwiftUI

final class RMSettingsViewController: UIViewController {

    private let settingsSwiftUIController = UIHostingController(
        rootView: RMSettingsView(
            viewModel: RMSettingsViewViewModel(
                cellViewModels: RMSettingsOption.allCases.compactMap({
        return RMSettingsCellViewModel(type: $0)
    }))))

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        self.title = "Settings"
        addSwiftUIController()
    }

    private func addSwiftUIController()  {
        addChild(settingsSwiftUIController)
        settingsSwiftUIController.didMove(toParent: self)
        
        view.addSubview(settingsSwiftUIController.view)
        settingsSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            settingsSwiftUIController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingsSwiftUIController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            settingsSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
