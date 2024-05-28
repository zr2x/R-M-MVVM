//
//  RMSearchView.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 12.05.2024.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject {
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
    
    func rmSearchView(_ searchView: RMSearchView, didSelectLocation location: RMLocation)
}

class RMSearchView: UIView {
    weak var delegate: RMSearchViewDelegate?
    let viewModel: RMSearchViewViewModel
    
    // MARK: - Subviews
    private let searchInputView = RMSearchInputView()
    private let noResultsView = RMNoSearchResultsView()
    private let resultsView = RMSearchResultView()

    // MARK: - Init
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(noResultsView, searchInputView, resultsView)
        setupConstraints()
        
        searchInputView.configure(with: RMSearchInputViewViewModel(type: viewModel.config.type))
        searchInputView.delegate = self
        resultsView.delegate = self
        setupHandlers(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110),
            
            resultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor,constant: 10),
            resultsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resultsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            resultsView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupHandlers(viewModel: RMSearchViewViewModel) {
        viewModel.registerOptionChangeBlock { tuple in
            self.searchInputView.update(option: tuple.0, value: tuple.1)
        }
        
        viewModel.registerSearchResultHandler { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.resultsView.configure(with: result)
                self.noResultsView.isHidden = true
                self.resultsView.isHidden = false
            }
        }
        
        viewModel.registerNoResultsHandler { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.noResultsView.isHidden = false
                self.resultsView.isHidden = true
            }
        }
    }
    
    // MARK: - Public
    
    public func presentKeyboard() {
        searchInputView.presentKeyboard()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension RMSearchView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


// MARK: - RMSearchInputViewDelegate

extension RMSearchView: RMSearchInputViewDelegate {
    func rmSearchInputViewDidTappedSearchButton(_ inputView: RMSearchInputView) {
        viewModel.executeSearch()
    }
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
        viewModel.set(updatedText: text)
    }
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        delegate?.rmSearchView(self, didSelectOption: option)
    }
}

// MARK: - RMSearchResultViewDelegate

extension RMSearchView: RMSearchResultViewDelegate {
    func rmSearchResultView(_ resultView: RMSearchResultView, didTapLocationAt index: Int) {
        guard let locationModel = viewModel.locationSearchResult(at: index) else { return }
        delegate?.rmSearchView(self, didSelectLocation: locationModel)
    }
}
