//
//  RMSearchResultView.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 19.05.2024.
//

import UIKit

protocol RMSearchResultViewDelegate: AnyObject {
    func rmSearchResultView(_ resultView: RMSearchResultView, didTapLocationAt index: Int)
    func rmSearchResultView(_ resultView: RMSearchResultView, didTapCharacternAt index: Int)
    func rmSearchResultView(_ resultView: RMSearchResultView, didTapLEpisodeAt index: Int)
}

/// Shows search results (table/collectionView as needed)
final class RMSearchResultView: UIView {
    
    
    /// TableView viewModels
    private var locationViewModels: [RMLocationTableViewCellViewModel] = []
    /// CollectionView viewModels
    private var collectionViewModels: [any Hashable] = []
    weak var delegate: RMSearchResultViewDelegate?
    
    private var viewModel: RMSearchResultViewModel? {
        didSet {
            processViewModel()
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.identifire)
        return tableView
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMFooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifire)
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.identifire)
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifire)
        return collectionView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        addSubviews(tableView, collectionView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func processViewModel() {
        guard let viewModel = viewModel else { return }
        
        switch viewModel.results {
        case .characters(let viewModels):
            collectionViewModels = viewModels
            setupCollectionView()
        case .episodes(let viewModels):
            collectionViewModels = viewModels
            setupCollectionView()
        case .locations(let viewModels):
            setupTableView(viewModels: viewModels)
        }    }

    private func setupCollectionView() {
        tableView.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = false
        collectionView.reloadData()
    }
    
    private func setupTableView(viewModels: [RMLocationTableViewCellViewModel]) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        collectionView.isHidden = true
        self.locationViewModels = viewModels
        tableView.reloadData()
    }
    
    // MARK: - Public
    
    public func configure(with viewModel: RMSearchResultViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension RMSearchResultView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locationViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.identifire, for: indexPath) as? RMLocationTableViewCell else {
            return UITableViewCell()
        }
        let viewModel = locationViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.rmSearchResultView(self, didTapLocationAt: indexPath.row)
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension RMSearchResultView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentViewModel = collectionViewModels[indexPath.row]
        if let viewModel = currentViewModel as? RMCharacterCollectionViewCellViewModel {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterCollectionViewCell.identifire,
                for: indexPath) as? RMCharacterCollectionViewCell else
            { return UICollectionViewCell() }
            cell.configure(with: viewModel)
            return cell
        } else if let viewModel = currentViewModel as? RMCharacterEpisodeCollectionViewCellViewModel {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifire,
                for: indexPath) as? RMCharacterEpisodeCollectionViewCell else
            { return UICollectionViewCell() }
            cell.configure(with: viewModel)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        
        let currentViewModel = collectionViewModels[indexPath.row]
        
        if currentViewModel is RMCharacterCollectionViewCellViewModel {
            let width = UIDevice.isIphone ? (bounds.width - 30)/2 : (bounds.width - 50)/3
            return CGSize(width: width, height: width * 1.5)
            
        } else if currentViewModel is RMCharacterEpisodeCollectionViewCellViewModel {
            let width = UIDevice.isIphone ? (bounds.width - 20) : (bounds.width - 50)/4
            return CGSize(width: width, height: 100)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        switch viewModel?.results {
        case .characters:
            delegate?.rmSearchResultView(self, didTapCharacternAt: indexPath.row)
        case .episodes:
            delegate?.rmSearchResultView(self, didTapLEpisodeAt: indexPath.row)
        case .locations:
            break // handle in tableView
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter, let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifire,
            for: indexPath) as? RMFooterLoadingCollectionReusableView else { return UICollectionReusableView() }
        if let viewModel = viewModel, viewModel.shouldShowLoadMoreIndicator {
            footer.startAnimating()
        }
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let viewModel = viewModel?.shouldShowLoadMoreIndicator else { return .zero }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

// MARK: - UIScrollViewDelegate
extension RMSearchResultView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !locationViewModels.isEmpty {
            handleLocationPagination(scrollView: scrollView)
        } else {
            handleCharacterOrEpisodePagination(scrollView: scrollView)
        }
    }
    
    private func handleCharacterOrEpisodePagination(scrollView: UIScrollView) {
        guard let viewModel = viewModel,
              !collectionViewModels.isEmpty,
              viewModel.shouldShowLoadMoreIndicator,
              !viewModel.isLoadingMoreResults else {
             return }
        
        
        Timer.scheduledTimer(withTimeInterval: 0.0, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.viewModel?.fetchAdditionalResults { [weak self] newResuls in
                    guard let self else { return }
                    DispatchQueue.main.async {
                        self.tableView.tableFooterView = nil
                        
                        let originalCount = self.collectionViewModels.count
                        let newCount = (newResuls.count - originalCount)
                        let total = originalCount + newCount
                        let startingIndex = total - newCount
                        let indexPathToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                            return IndexPath(row: $0, section: 0)
                        })
                        self.collectionViewModels = newResuls
                        self.collectionView.insertItems(at: indexPathToAdd)
                    }
                }
            }
            t.invalidate()
        }
    }
    
    private func handleLocationPagination(scrollView: UIScrollView) {
        guard let viewModel = viewModel,
              !locationViewModels.isEmpty,
              viewModel.shouldShowLoadMoreIndicator,
              !viewModel.isLoadingMoreResults else {
             return }
        
        
        Timer.scheduledTimer(withTimeInterval: 0.0, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                DispatchQueue.main.async {
                    self?.showTableLoadingIndicator()
                }
                self?.viewModel?.fetchAdditionalLocations { [weak self] newResuls in
                    self?.tableView.tableFooterView = nil
                    self?.locationViewModels = newResuls
                    self?.tableView.reloadData()
                }
            }
            t.invalidate()
        }
    }
    
    private func showTableLoadingIndicator() {
        let footer = RMTableFooterView(frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: frame.size.width,
                                                     height: 100))
        tableView.tableFooterView = footer
    }
}

