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
    var stats: Stats?

    fileprivate let aboutBackgroundView: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()

    fileprivate let statsBackgroundView: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()

    fileprivate lazy var aboutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.addTarget(self, action: #selector(aboutButtonAction), for: .touchUpInside)
        return button
    }()

    fileprivate lazy var statsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(statsButtonAction), for: .touchUpInside)
        return button
    }()

    fileprivate let aboutBackgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        return imageView
    }()

    fileprivate let statsBackgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        return imageView
    }()

    fileprivate lazy var aboutTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PokemonAboutLabelsTableViewCell.self,
                           forCellReuseIdentifier: PokemonAboutLabelsTableViewCell().identifier)
        tableView.register(PokemonBaseStatsTableViewCell.self,
                           forCellReuseIdentifier: PokemonBaseStatsTableViewCell().identifier)
        tableView.register(PokemonDefensesTableViewCell.self,
                           forCellReuseIdentifier: PokemonDefensesTableViewCell().identifier)
        return tableView
    }()

    fileprivate let selectionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.backgroundColor = .clear
        return stackView
    }()

    fileprivate var selectedView: PokemonViewSelection = .about

    fileprivate func addSubiviews() {

        self.view.addSubview(self.selectionStackView)
        self.view.addSubview(self.aboutTableView)
        self.selectionStackView.addArrangedSubview(self.aboutBackgroundView)
        self.selectionStackView.addArrangedSubview(self.statsBackgroundView)

        self.view.addSubview(self.aboutTableView)

        self.aboutBackgroundView.addSubview(self.aboutBackgroundImage)
        self.statsBackgroundView.addSubview(self.statsBackgroundImage)

        self.aboutBackgroundView.addSubview(self.aboutButton)
        self.statsBackgroundView.addSubview(self.statsButton)
    }

    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            self.selectionStackView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.selectionStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.selectionStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.selectionStackView.bottomAnchor.constraint(equalTo: self.aboutTableView.topAnchor),

            self.aboutBackgroundView.topAnchor.constraint(equalTo: self.selectionStackView.topAnchor),
            self.aboutBackgroundView.leadingAnchor.constraint(equalTo: self.selectionStackView.leadingAnchor),

            self.aboutBackgroundView.heightAnchor.constraint(equalToConstant: 50),

            self.statsBackgroundView.topAnchor.constraint(equalTo: self.selectionStackView.topAnchor),
            self.statsBackgroundView.trailingAnchor.constraint(equalTo: self.selectionStackView.trailingAnchor),
            self.statsBackgroundView.leadingAnchor.constraint(equalTo: self.aboutBackgroundView.trailingAnchor),

            self.statsBackgroundView.heightAnchor.constraint(equalToConstant: 50),

            self.aboutBackgroundImage.topAnchor.constraint(equalTo: self.aboutBackgroundView.topAnchor),
            self.aboutBackgroundImage.centerXAnchor.constraint(equalTo: self.aboutBackgroundView.centerXAnchor),

            self.aboutBackgroundImage.heightAnchor.constraint(equalToConstant: 100),
            self.aboutBackgroundImage.widthAnchor.constraint(equalToConstant: 100),

            self.aboutButton.topAnchor.constraint(equalTo: self.aboutBackgroundView.topAnchor),
            self.aboutButton.leadingAnchor.constraint(equalTo: self.aboutBackgroundView.leadingAnchor),
            self.aboutButton.trailingAnchor.constraint(equalTo: self.aboutBackgroundView.trailingAnchor),
            self.aboutButton.bottomAnchor.constraint(equalTo: self.aboutBackgroundView.bottomAnchor),

            self.statsBackgroundImage.topAnchor.constraint(equalTo: self.statsBackgroundView.topAnchor),
            self.statsBackgroundImage.centerXAnchor.constraint(equalTo: self.statsBackgroundView.centerXAnchor),

            self.statsBackgroundImage.heightAnchor.constraint(equalToConstant: 100),
            self.statsBackgroundImage.widthAnchor.constraint(equalToConstant: 100),

            self.statsButton.topAnchor.constraint(equalTo: self.statsBackgroundView.topAnchor),
            self.statsButton.leadingAnchor.constraint(equalTo: self.statsBackgroundView.leadingAnchor),
            self.statsButton.trailingAnchor.constraint(equalTo: self.statsBackgroundView.trailingAnchor),
            self.statsButton.bottomAnchor.constraint(equalTo: self.statsBackgroundView.bottomAnchor),

            self.aboutTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.aboutTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.aboutTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "background.\(basicInfo?.types[0] ?? "")")

        self.setupCustomTitle()
        self.setupBackButtonColor()

        self.aboutTableView.dataSource = self
        self.aboutTableView.delegate = self
        self.configureButtons()

        self.addSubiviews()
        self.setupConstraints()
    }

    @objc func aboutButtonAction(_ sender: UIButton) {
        if self.selectedView != .about {
            self.switchButtonStyle(.about)
            DispatchQueue.main.async {
                self.aboutTableView.reloadData()
            }
        }
    }
    @objc func statsButtonAction(_ sender: UIButton) {
        if self.selectedView != .stats {
            self.switchButtonStyle(.stats)
            DispatchQueue.main.async {
                self.aboutTableView.reloadData()
            }
        }
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
        if self.selectedView == .about {
            return 5
        } else {
            return 2
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedView == .about {
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
        } else {
            switch section {
            case 0:
                return 9
            case 1:
                return 4
            default:
                return 0
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.selectedView == .about {
            switch indexPath.section {
            case 0:
                return self.generateCell(indexPath: indexPath, infoType: .flavorText, text: about?.flavorText)
            case 1:
                return self.generateCell(indexPath: indexPath,
                                         data: about?.pokedex,
                                         infoType: .pokedexData,
                                         text: "Pokédex Data",
                                         colorName: basicInfo?.types[0])
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
        } else {
            if indexPath.section == 0 {
                return self.generateStatsCell(indexPath: indexPath, colorName: basicInfo?.types[0])
            } else {
                return self.generateStatsCell(indexPath: indexPath, colorName: basicInfo?.types[0], stats: self.stats)
            }
        }
    }

    fileprivate func generateStatsCell(indexPath: IndexPath,
                                       colorName: String?,
                                       stats: Stats?) -> PokemonDefensesTableViewCell {
        let identifier = "PokemonDefensesCell"
        guard let customCell = self.aboutTableView.dequeueReusableCell(
            withIdentifier: identifier, for: indexPath) as? PokemonDefensesTableViewCell
        else {
            fatalError("There should be a cell with \(identifier) identifier.")
        }
        customCell.row = indexPath.row
        customCell.color = UIColor(named: "type.\(colorName ?? "")")
        customCell.stats = stats
        customCell.setupData()

        return customCell
    }

    fileprivate func generateStatsCell(indexPath: IndexPath, colorName: String?) -> PokemonBaseStatsTableViewCell {
        let identifier = "PokemonBaseStatsCell"
        guard let customCell = self.aboutTableView.dequeueReusableCell(
            withIdentifier: identifier, for: indexPath) as? PokemonBaseStatsTableViewCell
        else {
            fatalError("There should be a cell with \(identifier) identifier.")
        }
        customCell.stats = self.stats
        customCell.row = indexPath.row
        customCell.color = UIColor(named: "type.\(colorName ?? "")")
        customCell.setupData()

        return customCell
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

        self.aboutButton.setTitle("About", for: .normal)
        self.statsButton.setTitle("Stats", for: .normal)

        self.aboutButton.tintColor = .white
        self.statsButton.tintColor = .white

        let fontSize = self.aboutButton.titleLabel?.font.pointSize ?? 0

        self.aboutButton.configuration?.titleTextAttributesTransformer
        = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
            return outgoing
        }

        let pokeBallIamge = UIImage(named: "image.pokeball")
        let tintedImage = pokeBallIamge?.withRenderingMode(.alwaysTemplate)

        self.aboutBackgroundImage.image = tintedImage?.maskWithGradientColor2(.white)
        self.aboutBackgroundImage.alpha = 0.45

        self.statsBackgroundImage.image = tintedImage?.maskWithGradientColor2(.white)
        self.statsBackgroundImage.alpha = 0.45

        self.statsBackgroundImage.isHidden = true
    }

    func switchButtonStyle(_ selected: PokemonViewSelection) {
        let fontSize = self.aboutButton.titleLabel?.font.pointSize ?? 0

        self.aboutButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        self.statsButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)

        self.aboutBackgroundImage.isHidden = true
        self.statsBackgroundImage.isHidden = true

        switch selected {
        case .about:
            self.aboutButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
            self.aboutBackgroundImage.comingFromRight(containerView: self.aboutButton)
            self.selectedView = .about
        case .stats:
            self.statsButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
            self.statsBackgroundImage.comingFromLeft(containerView: self.statsButton)
            self.selectedView = .stats
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
    case weaknessess
}

enum TypeRow: String {
    case first
    case second
}
