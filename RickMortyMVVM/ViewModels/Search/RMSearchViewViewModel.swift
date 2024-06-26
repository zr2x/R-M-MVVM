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
    private var searchResultHandler: ((RMSearchResultViewModel)->Void)?
    private var noResultsHandler: (() -> Void)?
    private var searchResultModel: Codable?
    
    let config: RMSearchViewController.Config
    
    // MARK: - Init
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    // MARK: - Private
    
    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: RMRequest) {
        RMService.shared.execute(request, expecting: type) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let model):
                self.processSearchResults(model: model)
            case .failure:
                self.handleNoResults()
            }
        }
    }
    
    private func processSearchResults(model: Codable) {
        var resultsViewModel: RMSearchResultViewType?
        var nextUrl: String?
        if let characterResults = model as? RMGetAllCharactersResponse {
            resultsViewModel = .characters(characterResults.results.compactMap({
                return RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image))
            }))
            nextUrl = characterResults.info.next
        } else if let episodesResults = model as? RMGetAllEpisodesResponse {
            resultsViewModel = .episodes(episodesResults.results.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
            }))
            nextUrl = episodesResults.info.next
        } else if let locationResults = model as? RMGetAllLocationsResponse {
            resultsViewModel = .locations(locationResults.results.compactMap({
                return RMLocationTableViewCellViewModel(location: $0)
            }))
            nextUrl = locationResults.info.next
        }
        if let results = resultsViewModel {
            searchResultModel = model
            let viewModel = RMSearchResultViewModel(results: results, next: nextUrl)
            searchResultHandler?(viewModel)
        } else {
            handleNoResults()
        }
    }
    
    private func handleNoResults() {
        noResultsHandler?()
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
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        var queryParam: [URLQueryItem] = [URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))]
        
        queryParam.append(contentsOf: optionMap.enumerated().compactMap({ _, element in
            let key = element.key
            let value = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
            
        }))
        let request = RMRequest(endpoint: config.type.endpoint,
                                queryParameters: queryParam)
        switch config.type.endpoint {
            case .character:
            makeSearchAPICall(RMGetAllCharactersResponse.self, request: request)
            case .episode:
            makeSearchAPICall(RMGetAllEpisodesResponse.self, request: request)
            case .location:
            makeSearchAPICall(RMGetAllLocationsResponse.self, request: request)
        }
    }
    
    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel) -> Void) {
        self.searchResultHandler = block
    }
    
    public func registerNoResultsHandler(_ block: @escaping () -> Void) {
        self.noResultsHandler = block
    }
    
    public func set(updatedText text: String) {
        self.searchText = text
    }
    
    public func locationSearchResult(at index: Int) -> RMLocation? {
        guard let searchModel = searchResultModel as? RMGetAllLocationsResponse else {
            return nil
        }
        if index <= searchModel.results.count {
            return searchModel.results[index]
        }
        return nil
    }
    
    public func characterSearchResult(at index: Int) -> RMCharacter? {
        guard let searchModel = searchResultModel as? RMGetAllCharactersResponse else {
            return nil }
        if index <= searchModel.results.count {
            return searchModel.results[index]
        }
        return nil
    }
    
    public func episodeSearchResult(at index: Int) -> RMEpisode? {
        guard let searchModel = searchResultModel as? RMGetAllEpisodesResponse else {
            return nil }
        if index <= searchModel.results.count {
            return searchModel.results[index]
        }
        return nil
    }
}
