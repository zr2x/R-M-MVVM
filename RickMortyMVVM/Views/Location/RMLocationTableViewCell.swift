//
//  RMLocationTableViewCell.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 11.05.2024.
//

import UIKit

final class RMLocationTableViewCell: UITableViewCell {
    static let identifire = "RMLocationTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .tertiarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func cofigure(with viewModel: RMLocationTableViewCellViewModel) {
        
    }

}
