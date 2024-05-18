//
//  RMSearchInputView.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 12.05.2024.
//

import UIKit

protocol RMSearchInputViewDelegate: AnyObject {
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
}

final class RMSearchInputView: UIView {
    
    weak var delegate: RMSearchInputViewDelegate?
    
    private var stackView: UIStackView?
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private var viewModel: RMSearchInputViewViewModel? {
        didSet {
            guard let viewModel = viewModel, viewModel.hasDynamicOption else {
                return
            }
            let options = viewModel.options
            createOptionSelectionViews(options: options)
        }
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(searchBar)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
    
    private func createOptionSelectionViews(options: [RMSearchInputViewViewModel.DynamicOption]) {
        let stackView = createOptionStackView()
        self.stackView = stackView
        
        for index in 0..<options.count {
            let option = options[index]
            let button = createButton(with: option, tag: index)
    
            button.tag = index
            stackView.addArrangedSubview(button)
        }
    }
    
    private func createButton(with option: RMSearchInputViewViewModel.DynamicOption, tag: Int) -> UIButton {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: option.rawValue, attributes: [
                        .font : UIFont.systemFont(
                        ofSize: 18,
                        weight: .medium),
                        .foregroundColor: UIColor.label]),
            for: .normal)
        button.backgroundColor = .secondarySystemFill
        button.layer.cornerRadius = 10
        button.tag = tag
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }
    
    private func createOptionStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        return stackView
    }
    
    @objc
    private func didTapButton(_ sender: UIButton) {
        guard let options = viewModel?.options else {
            return
        }
        let tag = sender.tag
        let selected = options[tag]
        delegate?.rmSearchInputView(self, didSelectOption: selected)
    }
    
    // MARK: - Public
    
    public func configure(with viewModel: RMSearchInputViewViewModel) {
        searchBar.placeholder = viewModel.searchPlaceHolderText
        self.viewModel = viewModel
    }
    
    public func presentKeyboard() {
        searchBar.becomeFirstResponder()
    }
    
    public func update(option: RMSearchInputViewViewModel.DynamicOption, value: String) {
        guard let buttons = stackView?.arrangedSubviews as? [UIButton],
              let options = viewModel?.options,
              let index = options.firstIndex(of: option) else { return }
        
        buttons[index].setAttributedTitle(NSAttributedString(
            string: value.uppercased(), attributes: [
                        .font : UIFont.systemFont(
                        ofSize: 18,
                        weight: .medium),
                        .foregroundColor: UIColor.link]),
            for: .normal)
    }
}
