//
//  RMSearchViewViewModel.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 12.05.2024.
//

import Foundation

final class RMSearchViewViewModel {
    
    private var optionMap: [RMSearchInputViewViewModel.DynamicOption: String] = [:]
    private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOption, String))-> Void)?
    private var searchText: String = ""
    private var searchResultHandler: (()->Void)?
    
    let config: RMSearchViewController.Config
    
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
        searchText = "Rick"
        var queryParam: [URLQueryItem] = [URLQueryItem(name: "name", value: searchText)]
        
        queryParam.append(contentsOf: optionMap.enumerated().compactMap({ _, element in
            let key = element.key
            let value = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
            
        }))
        
        var request = RMRequest(endpoint: config.type.endpoint,
                                queryParameters: queryParam)
        print(request.url?.absoluteString)
        RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            switch result {
            case .success(let model):
                print(model.results.count)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    public func registerSearchHandler(_ block: @escaping () -> Void) {
        self.searchResultHandler = block
    }
    
    public func set(query text: String) {
        self.searchText = text
    }
}
