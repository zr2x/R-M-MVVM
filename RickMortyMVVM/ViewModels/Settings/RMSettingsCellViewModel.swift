//
//  RMSettingsCellViewModel.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 10.05.2024.
//

import UIKit

struct RMSettingsCellViewModel: Identifiable {
    let id = UUID()
    
    public let type: RMSettingsOption
    public let onTapHandler: (RMSettingsOption) -> Void
    
    // MARK: - Init
    
    init(type: RMSettingsOption, onTapHandler: @escaping (RMSettingsOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
    
    // MARK: - Public
    
    public var image: UIImage? {
        return type.iconImage
    }
    
    public var  title: String {
        return type.displayTitle
    }
    
    public var iconContainterColor: UIColor {
        return type.iconContainterColor
    }
    
    // MARK: - Private
    
}

