//
//  RMLocationTableViewCellViewModel.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 11.05.2024.
//

import Foundation

struct RMLocationTableViewCellViewModel: Hashable {
    
    private let location: RMLocation
    
    init(location: RMLocation) {
        self.location = location
    }
    
    public var name: String {
        return "Name: \(location.name)"
    }
    
    public var type: String {
        return "Type: \(location.type)"
    }
    
    public var dimension: String {
        return "Dimension: \(location.dimension)"
    }
    
    // MARK: - Hashable
    
    static func == (lhs: RMLocationTableViewCellViewModel, rhs: RMLocationTableViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(location.id)
        hasher.combine(dimension)
        hasher.combine(type)
    }
}
