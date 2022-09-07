//
//  HomePokemonImageView.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 06/09/22.
//

import UIKit

class HomePokemonImageView: UIImageView {

    init() {
        super.init(frame: CGRect.zero)
        self.doInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func doInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
    }
}
