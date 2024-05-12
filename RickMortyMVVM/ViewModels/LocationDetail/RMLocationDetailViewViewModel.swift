//
//  RMLocationDetailViewViewModel.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 12.05.2024.
//

import Foundation

protocol RMLocationDetailViewViewModelDelegate: AnyObject {
    func didFetchLocationDetails()
}

final class RMLocationDetailViewViewModel {
    private let endpointUrl: URL?
    private var dataTuple: (location: RMLocation, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchLocationDetails()
        }
    }
    
    enum SectionType {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    weak var delegate: RMLocationDetailViewViewModelDelegate?
    public private(set) var cellViewModels: [SectionType] = []
    
    // MARK: - Init
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    // MARK: - Public
    /// Fetch backing location model
    public func fetchLocationData() {
        guard let url = endpointUrl,
              let request = RMRequest(url: url) else {
            return
        }
        RMService.shared.execute(request, expecting: RMLocation.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let model):
                self.fetchRelatedCharacters(location: model)
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
    public func character(at index: Int) -> RMCharacter? {
        guard let dataTuple = dataTuple else { return nil }
        return dataTuple.characters[index]
    }
    
    // MARK: - Private
    
    private func fetchRelatedCharacters(location: RMLocation) {
        let characterUrls = location.residents.compactMap({
            return URL(string: $0)
        })
        let requests = characterUrls.compactMap({
            return RMRequest(url: $0)
        })
        var characters = [RMCharacter]()
        let group = DispatchGroup()
        for request in requests {
            group.enter()
            RMService.shared.execute(request, expecting: RMCharacter.self) { [weak self] result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
        }
        group.notify(queue: .main) {
            self.dataTuple = (location: location, characters: characters)
        }
    }
    
    private func createCellViewModels() {
        guard let dataTuple = dataTuple else { return }
        let location = dataTuple.location
        let characters = dataTuple.characters
        
        var createdString = location.created
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: createdString) {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortFormatter.string(from: date)
        }
        cellViewModels = [.information(viewModels: [.init(title: "Location name:", value: location.name),
                                                    .init(title: "Location type:", value: location.type),
                                                    .init(title: "Dimension:", value: location.dimension),
                                                    .init(title: "Created:", value: createdString)]),
                          .characters(viewModel: characters.compactMap({
                              return RMCharacterCollectionViewCellViewModel(characterName: $0.name,
                                   characterStatus: $0.status,
                                   characterImageUrl: URL(string: $0.image))
                    }))]
        
    }
}

