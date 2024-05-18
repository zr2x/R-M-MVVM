//
//  RMSearchViewViewModel.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 12.05.2024.
//

import Foundation

final class RMSearchViewViewModel {
    
    let config: RMSearchViewController.Config
    private var optionMap: [RMSearchInputViewViewModel.DynamicOption: String] = [:]
    private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOption, String))-> Void)?
    private var searchText: String = ""
    
    // MARK: - Init
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    // MARK: - Public
    
    public func set(value: String, with option: RMSearchInputViewViewModel.DynamicOption) {
        optionMap.updateValue(value, forKey: option)
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }
    
    public func registerOptionChangeBlock(_ block: @escaping ((RMSearchInputViewViewModel.DynamicOption, String))-> Void) {
        self.optionMapUpdateBlock = block
    }
    
    public func executeSearch() {
        
    }
    
    public func set(query text: String) {
        self.searchText = text
    }
}
