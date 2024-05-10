//
//  RMSettingsCellViewModel.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 10.05.2024.
//

import UIKit

struct RMSettingsCellViewModel: Identifiable {
    let id = UUID()
    
    let type: RMSettingsOption
    
    // MARK: - Init
    
    init(type: RMSettingsOption) {
        self.type = type
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

