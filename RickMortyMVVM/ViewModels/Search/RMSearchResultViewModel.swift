//
//  RMSearchResultViewModel.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 18.05.2024.
//

import UIKit

final class RMSearchResultViewModel {
    private var next: String?
    
    public private(set) var results: RMSearchResultViewType
    
    public var shouldShowLoadMoreIndicator: Bool {
        return next != nil
    }
    
    public private(set) var isLoadingMoreResults: Bool = false
    
    init(results: RMSearchResultViewType, next: String?) {
        self.results = results
        self.next = next
    }
    
    public func fetchAdditionalLocations(completion: @escaping ([RMLocationTableViewCellViewModel]) -> Void) {
        guard !isLoadingMoreResults else {
            return }
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }
        isLoadingMoreResults = true
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            return }
        
        RMService.shared.execute(request, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                self.next = info.next

                let additionalLocations = moreResults.compactMap({
                    return RMLocationTableViewCellViewModel(location: $0)
                })
                var newResults: [RMLocationTableViewCellViewModel] = []
                switch self.results {
                case .locations(let existingResult):
                    newResults = existingResult + additionalLocations
                    self.results = .locations(newResults)
                case .characters, .episodes:
                    break
                }
                
                DispatchQueue.main.async {
                    self.isLoadingMoreResults = false
                    completion(newResults)
                }
            case .failure(let failure):
                print(String(describing: failure))
                self.isLoadingMoreResults = false
            }
        }
    }
    
    public func fetchAdditionalResults(completion: @escaping ([any Hashable]) -> Void) {
        guard !isLoadingMoreResults else {
            return }
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }
        isLoadingMoreResults = true
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            return }
        
        switch results {
        case .characters(let existingResults):
            RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    self.next = info.next
                    
                    let additionalResults = moreResults.compactMap({
                        return RMCharacterCollectionViewCellViewModel(characterName: $0.name,
                                                                      characterStatus: $0.status,
                                                                      characterImageUrl: URL(string: $0.image))
                    })
                    var newResults: [RMCharacterCollectionViewCellViewModel] = []
                    newResults = existingResults + additionalResults
                    self.results = .characters(newResults)
                    DispatchQueue.main.async {
                        self.isLoadingMoreResults = false
                        completion(newResults)
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    self.isLoadingMoreResults = false
                }
            }
        case .episodes(let existingResults):
            RMService.shared.execute(request, expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    self.next = info.next
                    
                    let additionalResults = moreResults.compactMap({
                        return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
                    })
                    var newResults: [RMCharacterEpisodeCollectionViewCellViewModel] = []
                    newResults = existingResults + additionalResults
                    self.results = .episodes(newResults)
                    DispatchQueue.main.async {
                        self.isLoadingMoreResults = false
                        completion(newResults)
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    self.isLoadingMoreResults = false
                }
            }
        case .locations:
            // handle in tableView
            break
        }
    }
}



enum RMSearchResultViewType {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
