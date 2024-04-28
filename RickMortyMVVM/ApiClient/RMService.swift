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
    
    /// API call
    /// - Parameters:
    ///   - request: Request instance
    ///   - type: The type which we are expecting to get back
    ///   - completion: Callback with data or error
    public func execute<T:Codable>(_ request: RMRequest, expecting type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
    }
}
