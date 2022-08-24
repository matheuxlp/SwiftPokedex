//
//  HomePokemonTableViewCell.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 23/08/22.
//

import UIKit
import Kingfisher

class HomePokemonTableViewCell: UITableViewCell {

    @IBOutlet weak var firstTypeStackView: UIStackView!
    @IBOutlet weak var secondTypeStackView: UIStackView!

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var firstTypeImage: UIImageView!
    @IBOutlet weak var firstTypeLabel: UILabel!

    @IBOutlet weak var secondTypeLabel: UILabel!
    @IBOutlet weak var secondTypeImage: UIImageView!

    @IBOutlet weak var pokemonImage: UIImageView!

    @IBOutlet weak var bgView: UIView!

    @IBOutlet weak var backgroundImagePokeball: UIImageView!
    @IBOutlet weak var backgroundImageDots: UIImageView!

    var pokemon: PokemonBasicInfo?

    func setupData() {

        self.firstTypeStackView.layer.cornerRadius = 4
        self.secondTypeStackView.layer.cornerRadius = 4

        if let poke = pokemon {

            let imgUrl: URL = URL(string: poke.artUrl ?? "")!
            self.pokemonImage.kf.setImage(with: imgUrl)

            let pokeBallIamge = UIImage(named: "image.pokeball")
            let tintedImage = pokeBallIamge?.withRenderingMode(.alwaysTemplate)
            self.backgroundImagePokeball.image = tintedImage?.maskWithGradientColor(.white)
            self.backgroundImagePokeball.alpha = 0.45

            let dotsImage = UIImage(named: "image.dots.big")
            let tintedDots = dotsImage?.withRenderingMode(.alwaysTemplate)
            self.backgroundImageDots.image = tintedDots?.maskWithGradientColor(.white)
            self.backgroundImageDots.alpha = 0.45

            self.bgView.backgroundColor = UIColor(named: "background.\(poke.types[0])")
            self.bgView.layer.cornerRadius = 4

            self.numberLabel.text = "#\(String(format: "%03d", poke.nationalNumber ?? 0))"
            self.nameLabel.text = poke.name?.capitalizingFirstLetter() ?? "no name"
            self.nameLabel.textColor = .white

            self.firstTypeLabel.text = poke.types[0].capitalizingFirstLetter()
            self.firstTypeImage.image = UIImage(named: "badge.\(poke.types[0])")
            self.firstTypeStackView.backgroundColor = UIColor(named: "type.\(poke.types[0])")

            if poke.types.count > 1 {
                self.secondTypeStackView.isHidden = false
                self.secondTypeLabel.text = poke.types[1].capitalizingFirstLetter()
                self.secondTypeImage.image = UIImage(named: "badge.\(poke.types[1])")
                self.secondTypeStackView.backgroundColor = UIColor(named: "type.\(poke.types[1])")
            } else {
                self.secondTypeStackView.isHidden = true
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
