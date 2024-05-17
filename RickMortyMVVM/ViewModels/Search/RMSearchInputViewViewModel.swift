//
//  RMSearchInputViewViewModel.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 12.05.2024.
//

import Foundation

final class RMSearchInputViewViewModel {
    private let type: RMSearchViewController.Config.`Type`
    
    enum DynamicOption: String {
        case status = "Status"
        case gender = "Gender"
        case locationType = "Location type"
    }
    
    // MARK: - Init
    init(type: RMSearchViewController.Config.`Type`) {
        self.type = type
    }
    
    
    // MARK: - Public
    
    public var hasDynamicOption: Bool {
        switch self.type {
        case .character, .location:
            return true
        case .episodes:
            return false
        }
    }
    
    public var options: [DynamicOption] {
        switch self.type {
        case .character:
            return [.status, .gender]
        case .location:
            return [.locationType]
        case .episodes:
            return []
        }
    }
    
    public var searchPlaceHolderText: String {
        switch self.type {
        case .character:
            return "Character name"
        case .location:
            return "Location name"
        case .episodes:
            return "Episode title"
        }
    }
}
