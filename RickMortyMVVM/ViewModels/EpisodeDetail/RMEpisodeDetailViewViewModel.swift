//
//  RMEpisodeDetailViewViewModel.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 05.05.2024.
//

import UIKit

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}

final class RMEpisodeDetailViewViewModel {
    private let endpointUrl: URL?
    private var dataTuple: (RMEpisode, [RMCharacter])? {
        didSet {
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    enum SectionType {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    weak var delegate: RMEpisodeDetailViewViewModelDelegate?
    public private(set) var sections: [SectionType] = []
    
    // MARK: - Init
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    // MARK: - Public
    
    /// Fetch backing episode model
    public func fetchEpisodeData() {
        guard let url = endpointUrl,
              let request = RMRequest(url: url) else {
            return
        }
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let model):
                self.fetchRelatedCharacters(episode: model)
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
    // MARK: - Private
    
    private func fetchRelatedCharacters(episode: RMEpisode) {
        let characterUrls = episode.characters.compactMap({
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
                case .failure(let failure):
                    break
                }
            }
        }
        group.notify(queue: .main) {
            self.dataTuple = (episode, characters)
        }
    }
}
