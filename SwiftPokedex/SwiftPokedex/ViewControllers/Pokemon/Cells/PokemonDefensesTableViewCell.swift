//
//  PokemonDefesnesTableViewCell.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 10/09/22.
//

import UIKit

class PokemonDefensesTableViewCell: UITableViewCell {

    let identifier: String = "PokemonDefensesCell"
    var color: UIColor?
    var row: Int?
    var stats: Stats?

    let firstRowTypes: [String] = ["normal", "fire", "water", "electric", "grass",
                                   "ice", "fighting", "poison", "ground"]
    let secondRowTypes: [String] = ["flying", "psychic", "bug", "rock", "ghost",
                                    "dragon", "dark", "steel", "fairy"]

    internal let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    internal var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 2
        return stackView
    }()

    internal func setupConstraints() {
        NSLayoutConstraint.activate([
            self.mainStackView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.mainStackView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            self.mainStackView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            self.mainStackView.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.label.isHidden = true
        for view in self.mainStackView.subviews {
            view.removeFromSuperview()
        }
    }

    internal func addImages(_ types: [String]) {
        for count in 0...8 {
            let label: UILabel = {
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                if let defense = (self.stats?.defenses ?? []).first(where: { $0.name == types[count] }) {
                    label.text = self.damageConverter(defense.relation)
                } else {
                    label.text = " "
                }
                return label
            }()
            let imageView: UIImageView = {
                let imageView = UIImageView()
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.backgroundColor = .clear
                imageView.image = UIImage(named: "badge.\(types[count])")?
                    .imageWithSpacing(insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
                imageView.backgroundColor = UIColor(named: "type.\(types[count])")
                return imageView
            }()
            let stackView: UIStackView = {
                let stackView = UIStackView()
                stackView.translatesAutoresizingMaskIntoConstraints = false
                stackView.alignment = .center
                stackView.axis = .vertical
                stackView.distribution = .fillEqually
                stackView.spacing = 0
                return stackView
            }()
            imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            stackView.addArrangedSubview(imageView)
            stackView.addArrangedSubview(label)
            self.mainStackView.addArrangedSubview(stackView)
        }
    }

    func setupData() {
        print(stats?.defenses ?? [])
        self.contentView.addSubview(self.mainStackView)
        self.mainStackView.addArrangedSubview(self.label)
        self.setupConstraints()
        switch self.row {
        case 0:
            self.mainStackView.alignment = .leading
            self.label.isHidden = false
            self.label.text = "Type Defenses"
            self.label.textColor = self.color
            self.label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        case 1:
            self.mainStackView.alignment = .leading
            self.label.isHidden = false
            self.label.text = "The effectiveness of each type on Bulbasaur."
            self.label.numberOfLines = 0
            self.label.textColor = .systemGray
        case 2:
            self.addImages(self.firstRowTypes)
        case 3:
            self.addImages(self.secondRowTypes)
        default:
            return
        }
    }

    fileprivate func damageConverter(_ damageString: String) -> String {
        if damageString == "normal_damage_from" {
            return " "
        } else if damageString == "half_damage_from" {
            return "1/2"
        } else if damageString == "quarter_damage_from" {
            return "1/4"
        } else if damageString == "double_damage_from" {
            return "2"
        } else {
            return ""
        }
    }

}
class PaddedImageView: UIImageView {
    override var alignmentRectInsets: UIEdgeInsets {
        return UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
    }
}
