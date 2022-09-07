//
//  HomePokemonCellLabel.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 06/09/22.
//

import UIKit

class HomePokemonCellLabel: UILabel {

    init(size: CGFloat, weight: UIFont.Weight = .medium, color: UIColor = .black) {
        super.init(frame: CGRect.zero)
        self.doInit(size: size, weight: weight, color: color)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func doInit(size: CGFloat, weight: UIFont.Weight = .medium, color: UIColor = .black) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont.systemFont(ofSize: size, weight: weight)
        self.textColor = color
    }
}
