//
//  RMSearchResultViewModel.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 18.05.2024.
//

import UIKit

enum RMSearchResultViewModel {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
