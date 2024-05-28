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
}

enum RMSearchResultViewType {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
