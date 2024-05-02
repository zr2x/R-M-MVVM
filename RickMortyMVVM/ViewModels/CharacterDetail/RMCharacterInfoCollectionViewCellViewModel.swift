//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 01.05.2024.
//

import Foundation

final class RMCharacterInfoCollectionViewCellViewModel {
    public let value: String
    public let title: String
    init(value: String, title: String) {
        self.value = value
        self.title = title
    }
}
