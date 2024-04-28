//
//  Extensions.swift
//  RickMortyMVVM
//
//  Created by Искандер Ситдиков on 28.04.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            self.addSubview($0)
        })
    }
}
