//
//  RMEndpoint.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 27.04.2024.
//

import Foundation

@frozen enum RMEndpoint: String, Hashable, CaseIterable {
    case character
    case location
    case episode
}
