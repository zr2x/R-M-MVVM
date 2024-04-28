//
//  RMService.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 27.04.2024.
//

import Foundation


final class RMService {
    static let shared = RMService()
    
    private init () {}
    
    public func execute(_ request: RMRequest, completion: @escaping () -> Void) {
        
    }
}
