//
//  TypeStackView.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 06/09/22.
//

import UIKit

class TypeStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.doInit()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func doInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.alignment = .center
        self.distribution = .fillProportionally
        self.spacing = 5
        self.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.isLayoutMarginsRelativeArrangement = true
        self.layer.cornerRadius = 4
    }
}
