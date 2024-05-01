//
//  RMCharacterDetailViewViewModel.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 29.04.2024.
//

import Foundation

class RMCharacterDetailViewViewModel {
    
    private let character: RMCharacter
    
    enum SectionType: CaseIterable {
        case photo
        case information
        case episodes
    }
    
    public let sections = SectionType.allCases
    
    // MARK: - Init
    init(character: RMCharacter) {
        self.character = character
    }
    
    private var requestUrl: URL? {
        return URL(string: character.url)
    }
    
    public var title: String {
        character.name
    }
    

}
