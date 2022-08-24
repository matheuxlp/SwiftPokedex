//
//  PokemonViewController.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 24/08/22.
//

import UIKit
import SwiftUI

// title change in prepare for segue

class PokemonViewController: UIViewController {

    var basicInfo: PokemonBasicInfo?
    var about: About?

    @IBOutlet weak fileprivate var stackView: UIStackView!

    @IBOutlet weak fileprivate var aboutBackgroundView: UIView!
    @IBOutlet weak fileprivate var statsBackgroundView: UIView!

    @IBOutlet weak fileprivate var aboutButtonOutlet: UIButton!
    @IBOutlet weak fileprivate var statsButtonOutlet: UIButton!

    @IBOutlet weak fileprivate var aboutBackgorundImage: UIImageView!
    @IBOutlet weak fileprivate var statsBackgroundImage: UIImageView!

    @IBOutlet weak fileprivate var aboutTableView: UITableView!

    fileprivate var selectedView: PokemonViewSelection = .about

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "background.\(basicInfo?.types[0] ?? "")")

        self.setupCustomTitle()
        self.setupBackButtonColor()

        self.aboutTableView.dataSource = self
        self.aboutTableView.delegate = self
        self.configureButtons()
    }

    @IBAction func aboutButtonAction(_ sender: UIButton) {
        self.switchButtonStyle(.about)
    }
    @IBAction func statsButtonAction(_ sender: UIButton) {
        self.switchButtonStyle(.stats)
    }

    fileprivate func setupCustomTitle() {
        let titleLabel = UILabel()
        let firstAttr: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 26),
                                                        .foregroundColor: UIColor.white]
        let attrString = NSMutableAttributedString(string: "\(basicInfo?.name?.capitalizingFirstLetter() ?? "Pokémon")",
                                                   attributes: firstAttr)
        titleLabel.attributedText = attrString
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel

        self.navigationItem.largeTitleDisplayMode = .never
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
    }

    fileprivate func setupBackButtonColor() {
        self.navigationController?.navigationBar.tintColor = .white
    }
}

extension PokemonViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 6
        case 2:
            return 6
        case 3:
            return 4
        case 4:
            return self.about?.pokedexNumbers.count ?? 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
             return self.generateCell(indexPath: indexPath, infoType: .flavorText, text: about?.flavorText)
        case 1: // pokedex data
            if indexPath.row == 5 {
                let identifier = "PokemonAboutIconsCell"
                guard let customCell = self.aboutTableView.dequeueReusableCell(
                    withIdentifier: identifier, for: indexPath) as? PokemonAboutIconsTableViewCell
                else {
                    fatalError("There should be a cell with \(identifier) identifier.")
                }
                customCell.weaknesses = about?.pokedex.weaknesses
                customCell.setupData()
                return customCell
            } else {
                return self.generateCell(indexPath: indexPath,
                                         data: about?.pokedex,
                                         infoType: .pokedexData,
                                         text: "Pokédex Data",
                                         colorName: basicInfo?.types[0])
            }
        case 2:
            return self.generateCell(indexPath: indexPath,
                                     data: about?.training,
                                     infoType: .training,
                                     text: "Training",
                                     colorName: basicInfo?.types[0])
        case 3:
            return self.generateCell(indexPath: indexPath,
                                     data: about?.breeding,
                                     infoType: .breeding,
                                     text: "Breeding",
                                     colorName: basicInfo?.types[0])
        default:
            return self.generateCell(indexPath: indexPath,
                                     data: about?.pokedexNumbers,
                                     infoType: .numbers,
                                     text: "Pokédex Entry Number",
                                     colorName: basicInfo?.types[0])
        }
    }

    fileprivate func generateCell(indexPath: IndexPath,
                                  infoType: AboutPokemonInfoType,
                                  text: String? = nil) -> PokemonAboutLabelsTableViewCell {
        let identifier = "PokemonAboutLabelsCell"
        guard let customCell = self.aboutTableView.dequeueReusableCell(
            withIdentifier: identifier, for: indexPath) as? PokemonAboutLabelsTableViewCell
        else {
            fatalError("There should be a cell with \(identifier) identifier.")
        }
        customCell.infoType = infoType
        customCell.row = indexPath.row
        customCell.text = text
        customCell.setupData()

        return customCell
    }

    fileprivate func generateCell(indexPath: IndexPath,
                                  data: Any?,
                                  infoType: AboutPokemonInfoType,
                                  text: String? = nil,
                                  colorName: String? = nil) -> PokemonAboutLabelsTableViewCell {
        let identifier = "PokemonAboutLabelsCell"
        guard let customCell = self.aboutTableView.dequeueReusableCell(
            withIdentifier: identifier, for: indexPath) as? PokemonAboutLabelsTableViewCell
        else {
            fatalError("There should be a cell with \(identifier) identifier.")
        }

        customCell.data = data
        customCell.infoType = infoType
        customCell.row = indexPath.row
        customCell.text = text
        customCell.color = UIColor(named: "type.\(colorName ?? "")")
        customCell.setupData()

        return customCell
    }
}

// MARK: - Buttons Configuration

extension PokemonViewController {
    func configureButtons() {
        self.aboutBackgroundView.backgroundColor = .clear
        self.statsBackgroundView.backgroundColor = .clear

        self.aboutButtonOutlet.setTitle("About", for: .normal)
        self.statsButtonOutlet.setTitle("Stats", for: .normal)

        self.aboutButtonOutlet.tintColor = .white
        self.statsButtonOutlet.tintColor = .white

        let fontSize = self.aboutButtonOutlet.titleLabel?.font.pointSize ?? 0

        self.aboutButtonOutlet.configuration?.titleTextAttributesTransformer
        = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
            return outgoing
        }

        let pokeBallIamge = UIImage(named: "image.pokeball")
        let tintedImage = pokeBallIamge?.withRenderingMode(.alwaysTemplate)

        self.aboutBackgorundImage.image = tintedImage?.maskWithGradientColor2(.white)
        self.aboutBackgorundImage.alpha = 0.45

        self.statsBackgroundImage.image = tintedImage?.maskWithGradientColor2(.white)
        self.statsBackgroundImage.alpha = 0.45

        self.statsBackgroundImage.isHidden = true
    }

    func switchButtonStyle(_ selected: PokemonViewSelection) {
        let fontSize = self.aboutButtonOutlet.titleLabel?.font.pointSize ?? 0

        self.aboutButtonOutlet.configuration?.titleTextAttributesTransformer
        = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
            return outgoing
        }
        self.statsButtonOutlet.configuration?.titleTextAttributesTransformer
        = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
            return outgoing
        }

        self.aboutBackgorundImage.isHidden = true
        self.statsBackgroundImage.isHidden = true

        switch selected {
        case .about:
            print("got here")
            self.aboutButtonOutlet.configuration?.titleTextAttributesTransformer
            = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
                return outgoing
            }
            self.aboutBackgorundImage.comingFromRight(containerView: self.aboutButtonOutlet)
        case .stats:
            self.statsButtonOutlet.configuration?.titleTextAttributesTransformer
            = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
                return outgoing
            }
            self.statsBackgroundImage.comingFromLeft(containerView: self.statsButtonOutlet)
        }
    }
}

enum PokemonViewSelection: String {
    case about
    case stats
}

enum AboutPokemonInfoType: String {
    case flavorText
    case pokedexEntry
    case pokedexData
    case training
    case breeding
    case numbers
}
