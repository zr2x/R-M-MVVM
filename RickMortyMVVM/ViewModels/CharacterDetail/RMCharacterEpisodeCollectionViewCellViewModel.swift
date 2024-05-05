//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 01.05.2024.
//

import Foundation

protocol RMEpisodeDataRender {
    var episode: String { get }
    var name: String { get }
    var airDate: String { get }
}

final class RMCharacterEpisodeCollectionViewCellViewModel: Hashable {
    private let episodeDataUrl: URL?
    private var isFetching = false
    private var dataBlock: ((RMEpisodeDataRender) -> Void)?
    private var episode: RMEpisode? {
        didSet {
            guard let model = episode else { return }
            dataBlock?(model)
        }
    }
    
    // MARK: - Init
    
    init(episodeDataUrl: URL?) {
        self.episodeDataUrl = episodeDataUrl
    }
    
    //MARK: - Public
    
    public func registerForData(_ block: @escaping (RMEpisodeDataRender) -> Void) {
        self.dataBlock = block
    }
    
    public func fetchEpisode() {
        guard !isFetching else { 
            if let model = episode {
                dataBlock?(model)
            }
                return}
        guard let url = episodeDataUrl,
              let request = RMRequest(url: url)
              else { return }
        isFetching = true
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self?.episode = model
                }
            case .failure(let failure):
                break
            }
        }
    }
    
    // MARK: - Hashable
    
    static func == (lhs: RMCharacterEpisodeCollectionViewCellViewModel, rhs: RMCharacterEpisodeCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataUrl?.absoluteString)
    }
}
