//
//  RMSettingsOption.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 10.05.2024.
//

import UIKit

enum RMSettingsOption: CaseIterable {
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewGit
    
    var targetUrl: URL? {
        switch self {
        case .rateApp:
            return nil
        case .contactUs:
            return URL(string: "https://www.linkedin.com/in/iskander-sitdikov-82420825b/")
        case .terms:
            return URL(string: "https://shorturl.at/gozQ9")
        case .privacy:
            return URL(string: "https://shorturl.at/bsEY2")
        case .apiReference:
            return URL(string: "https://rickandmortyapi.com/")
        case .viewGit:
            return URL(string: "https://github.com/zr2x")
        }
    }
    
    var displayTitle: String {
        switch self {
        case .rateApp:
            "Rate app"
        case .contactUs:
            "Contact us"
        case .terms:
            "Term of service"
        case .privacy:
            "Privacy"
        case .apiReference:
            "Api"
        case .viewGit:
            "View git"
        }
    }
    
    var iconContainterColor: UIColor {
        switch self {
        case .rateApp:
                .systemBlue
        case .contactUs:
                .systemCyan
        case .terms:
                .systemMint
        case .privacy:
                .systemTeal
        case .apiReference:
                .systemOrange
        case .viewGit:
                .systemPurple
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            UIImage(systemName: "star.fill")
        case .contactUs:
            UIImage(systemName: "paperplane.fill")
        case .terms:
            UIImage(systemName: "doc.fill")
        case .privacy:
            UIImage(systemName: "lock.fill")
        case .apiReference:
            UIImage(systemName: "list.clipboard.fill")
        case .viewGit:
            UIImage(systemName: "link.circle.fill")
        }
    }
}
