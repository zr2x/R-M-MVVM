//
//  RMLocationViewViewModel.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 11.05.2024.
//

import Foundation

protocol RMLocationViewViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}

final class RMLocationViewViewModel {
    weak var delegate: RMLocationViewViewModelDelegate?
    
    private var locations: [RMLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = RMLocationTableViewCellViewModel(location: location)
                cellViewModels.append(cellViewModel)
                
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
    
    private var apiInfo: RMGetAllLocationsResponse.Info?
    
    public func fetchLocation() {
        RMService.shared.execute(.listLocationsRequest, 
                                 expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let model):
                self.apiInfo = model.info
                self.locations = model.results
                DispatchQueue.main.async {
                    self.delegate?.didFetchInitialLocations()
                }
            case .failure:
                break
            }
        }
    }
    
    private var hasMoreResults: Bool {
        return false
    }
    
}
