//
//  HomePokemonTableViewCell.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 06/09/22.
//

import UIKit
import Kingfisher

class HomePokemonTableViewCell: UITableViewCell {

    let identifier: String = "HomePokemonTableViewCell"

    internal let typeBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        return view
    }()

    internal let pokemonImageView: UIImageView = HomePokemonImageView()

    internal let numberLabel: UILabel = HomePokemonCellLabel(size: 14, color: .darkGray)

    internal let nameLabel: UILabel = HomePokemonCellLabel(size: 28, weight: .bold, color: .white)

    internal let firstTypeStackView: UIStackView = TypeStackView()

    internal let firstTypeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        return imageView
    }()

    internal let firstTypeLabel: UILabel = HomePokemonCellLabel(size: 14, color: .white)

    internal let secondTypeStackView: UIStackView = TypeStackView()

    internal let secondTypeImageView: UIImageView = HomePokemonImageView()

    internal let secondTypeLabel: UILabel = HomePokemonCellLabel(size: 14, color: .white)

    internal let pokeballImageView: UIImageView = HomePokemonImageView()

    internal let patternImageView: UIImageView = HomePokemonImageView()

    var pokemon: PokemonBasicInfo?

    internal func setupConstraints() {
        NSLayoutConstraint.activate([
            self.typeBackgroundView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            self.typeBackgroundView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.typeBackgroundView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.typeBackgroundView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),

            self.pokemonImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.pokemonImageView.trailingAnchor.constraint(equalTo: self.typeBackgroundView.trailingAnchor),
            self.pokemonImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -20),
            self.pokemonImageView.widthAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -20),

            self.numberLabel.topAnchor.constraint(equalTo: self.typeBackgroundView.topAnchor, constant: 15),
            self.numberLabel.leadingAnchor.constraint(equalTo: self.typeBackgroundView.leadingAnchor, constant: 20),

            self.nameLabel.topAnchor.constraint(equalTo: self.numberLabel.bottomAnchor),
            self.nameLabel.leadingAnchor.constraint(equalTo: self.typeBackgroundView.leadingAnchor, constant: 20),

            self.firstTypeStackView.bottomAnchor.constraint(equalTo: self.typeBackgroundView.bottomAnchor,
                                                            constant: -15),
            self.firstTypeStackView.leadingAnchor.constraint(equalTo: self.typeBackgroundView.leadingAnchor,
                                                             constant: 20),
            self.secondTypeStackView.bottomAnchor.constraint(equalTo: self.typeBackgroundView.bottomAnchor,
                                                            constant: -15),
            self.secondTypeStackView.leadingAnchor.constraint(equalTo: self.firstTypeStackView.trailingAnchor,
                                                              constant: 5),

            self.pokeballImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.pokeballImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.pokeballImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -20),
            self.pokeballImageView.widthAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -20),

            self.patternImageView.topAnchor.constraint(equalTo: self.typeBackgroundView.topAnchor, constant: 5),
            self.patternImageView.trailingAnchor.constraint(equalTo: self.pokeballImageView.leadingAnchor,
                                                            constant: -30),
            self.patternImageView.heightAnchor.constraint(equalToConstant: 40),
            self.patternImageView.widthAnchor.constraint(equalToConstant: 90)
        ])
    }

    internal func addSubviews() {
        self.contentView.addSubview(self.typeBackgroundView)
        self.contentView.addSubview(self.pokemonImageView)

        self.contentView.addSubview(self.numberLabel)
        self.contentView.addSubview(self.nameLabel)

        self.contentView.addSubview(self.firstTypeStackView)
        self.contentView.addSubview(self.secondTypeStackView)

        self.typeBackgroundView.addSubview(self.pokeballImageView)
        self.typeBackgroundView.addSubview(self.patternImageView)

        self.firstTypeStackView.addArrangedSubview(self.firstTypeImageView)
        self.firstTypeStackView.addArrangedSubview(self.firstTypeLabel)

        self.secondTypeStackView.addArrangedSubview(self.secondTypeImageView)
        self.secondTypeStackView.addArrangedSubview(self.secondTypeLabel)
    }

    func setupData() {
        self.addSubviews()
        self.setupConstraints()

        if let poke = pokemon {
            print("got here")
            self.typeBackgroundView.backgroundColor = UIColor(named: "background.\(poke.types[0])")
            let imgUrl: URL = URL(string: poke.artUrl ?? "")!
            self.pokemonImageView.kf.setImage(with: imgUrl)

            self.numberLabel.text = "#\(String(format: "%03d", poke.nationalNumber ?? 0))"
            self.nameLabel.text = poke.name?.capitalizingFirstLetter() ?? "no name"

            self.firstTypeLabel.text = poke.types[0].capitalizingFirstLetter()
            self.firstTypeImageView.image = UIImage(named: "badge.\(poke.types[0])")
            self.firstTypeStackView.backgroundColor = UIColor(named: "type.\(poke.types[0])")
            if poke.types.count > 1 {
                self.secondTypeStackView.isHidden = false
                self.secondTypeLabel.text = poke.types[1].capitalizingFirstLetter()
                self.secondTypeImageView.image = UIImage(named: "badge.\(poke.types[1])")
                self.secondTypeStackView.backgroundColor = UIColor(named: "type.\(poke.types[1])")
            }

            let pokeBallIamge = UIImage(named: "image.pokeball")
            let tintedImage = pokeBallIamge?.withRenderingMode(.alwaysTemplate)
            self.pokeballImageView.image = tintedImage?.maskWithGradientColor(.white)
            self.pokeballImageView.alpha = 0.45

            let dotsImage = UIImage(named: "image.dots.big")
            let tintedDots = dotsImage?.withRenderingMode(.alwaysTemplate)
            self.patternImageView.image = tintedDots?.maskWithGradientColor(.white)
            self.patternImageView.alpha = 0.45
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
