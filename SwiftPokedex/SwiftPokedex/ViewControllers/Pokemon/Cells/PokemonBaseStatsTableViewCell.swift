//
//  PokemonStatsTableViewCell.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 10/09/22.
//

import UIKit

class PokemonBaseStatsTableViewCell: UITableViewCell {

    let identifier: String = "PokemonBaseStatsCell"
    var color: UIColor?
    var row: Int?
    var stats: Stats?

    internal lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = self.color
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    internal let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.backgroundColor = .clear
        return stackView
    }()

    internal let firstStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
    }()

    internal let secondStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()

    internal let firstLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()

    internal let secondLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()

    internal let thirdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    internal let forthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    internal lazy var progressBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = self.color
        progressView.trackTintColor = .clear
        progressView.progress = 10

        return progressView
    }()

    internal func addSubviews() {
        self.contentView.addSubview(self.mainStackView)

        self.mainStackView.addArrangedSubview(self.firstStackView)
        self.mainStackView.addArrangedSubview(self.progressBar)
        self.mainStackView.addArrangedSubview(self.secondStackView)

        self.firstStackView.addArrangedSubview(self.firstLabel)
        self.firstStackView.addArrangedSubview(self.secondLabel)

        self.secondStackView.addArrangedSubview(self.thirdLabel)
        self.secondStackView.addArrangedSubview(self.forthLabel)
    }

    internal func setupConstraints() {
        NSLayoutConstraint.activate([
            self.mainStackView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.mainStackView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            self.mainStackView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            self.mainStackView.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }

    func setupData() {
        self.addSubviews()
        self.setupConstraints()

        guard let data = self.stats else { return }
        guard let base = data.baseStats else {return}
        guard let max = data.maxSatas else {return}
        guard let min = data.minStats else {return}
        switch self.row {
        case 0:
            self.progressBar.isHidden = true
            self.secondStackView.isHidden = true
            self.secondLabel.isHidden = true
            self.firstLabel.text = "Stats"
            self.firstLabel.textColor = self.color
            self.firstLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        case 1:
            self.firstLabel.text = "HP"
            self.firstLabel.font = UIFont.systemFont(ofSize: 12)
            self.secondLabel.text = "\(base.healthPoints ?? 0)"
            self.secondLabel.textColor = .systemGray
            self.thirdLabel.text = "\(min.healthPoints ?? 0)"
            self.forthLabel.text = "\(max.healthPoints ?? 0)"
            self.progressBar.progress = Float(base.healthPoints ?? 0) / Float(max.healthPoints ?? 0) * 2
        case 2:
            self.firstLabel.text = "Attack"
            self.firstLabel.font = UIFont.systemFont(ofSize: 12)
            self.secondLabel.text = "\(base.attack ?? 0)"
            self.secondLabel.textColor = .systemGray
            self.thirdLabel.text = "\(min.attack ?? 0)"
            self.forthLabel.text = "\(max.attack ?? 0)"
            self.progressBar.progress = Float(base.attack ?? 0) / Float(max.attack ?? 0) * 2
        case 3:
            self.firstLabel.text = "Defense"
            self.firstLabel.font = UIFont.systemFont(ofSize: 12)
            self.secondLabel.text = "\(base.defense ?? 0)"
            self.secondLabel.textColor = .systemGray
            self.thirdLabel.text = "\(min.defense ?? 0)"
            self.forthLabel.text = "\(max.defense ?? 0)"
            self.progressBar.progress = Float(base.defense ?? 0) / Float(max.defense ?? 0) * 2
        case 4:
            self.firstLabel.text = "Sp. Atk"
            self.firstLabel.font = UIFont.systemFont(ofSize: 12)
            self.secondLabel.text = "\(base.specialAttack ?? 0)"
            self.secondLabel.textColor = .systemGray
            self.thirdLabel.text = "\(min.specialAttack ?? 0)"
            self.forthLabel.text = "\(max.specialAttack ?? 0)"
            self.progressBar.progress = Float(base.specialAttack ?? 0) / Float(max.specialAttack ?? 0) * 2
        case 5:
            self.firstLabel.text = "Sp. Def"
            self.firstLabel.font = UIFont.systemFont(ofSize: 12)
            self.secondLabel.text = "\(base.specialDefense ?? 0)"
            self.secondLabel.textColor = .systemGray
            self.thirdLabel.text = "\(min.specialDefense ?? 0)"
            self.forthLabel.text = "\(max.specialDefense ?? 0)"
            self.progressBar.progress = Float(base.specialDefense ?? 0) / Float(max.specialDefense ?? 0) * 2
        case 6:
            self.firstLabel.text = "Speed"
            self.firstLabel.font = UIFont.systemFont(ofSize: 12)
            self.secondLabel.text = "\(base.speed ?? 0)"
            self.secondLabel.textColor = .systemGray
            self.thirdLabel.text = "\(min.speed ?? 0)"
            self.forthLabel.text = "\(max.speed ?? 0)"
            self.progressBar.progress = Float(base.speed ?? 0) / Float(max.speed ?? 0) * 2
        case 7:
            self.firstLabel.text = "Total"
            self.firstLabel.font = UIFont.systemFont(ofSize: 12)
            self.secondLabel.text = "\(self.getTotals(data: base))"
            self.secondLabel.textColor = .systemGray
            self.secondLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            self.thirdLabel.text = "Min"
            self.thirdLabel.font = UIFont.systemFont(ofSize: 14)
            self.forthLabel.text = "Max"
            self.forthLabel.font = UIFont.systemFont(ofSize: 14)
            self.progressBar.progress = 0
            self.progressBar.trackTintColor = .clear
        case 8:
            self.firstLabel.text = "The ranges shown on the right are for a level 100 Pokémon. "
                                 + "Maximum values are based on a beneficial nature, 252 EVs, 31 IVs; "
                                 + "minimum values are based on a hindering nature, 0 EVs, 0 IVs."
            self.firstLabel.font = UIFont.systemFont(ofSize: 14)
            self.firstLabel.textColor = .darkGray
            self.firstLabel.numberOfLines = 0
            self.secondLabel.isHidden = true
            self.progressBar.isHidden = true
            self.secondStackView.isHidden = true
        default:
            self.firstLabel.text = "sdsdsds1"
            self.secondLabel.text = "second"
            self.thirdLabel.text = "third"
            self.forthLabel.text = "forth"
        }
    }

    internal func getTotals(data: BaseStats) -> Int {
        var total: Int = 0
        total += data.healthPoints ?? 0
        total += data.attack ?? 0
        total += data.defense ?? 0
        total += data.specialAttack ?? 0
        total += data.specialDefense ?? 0
        total += data.speed ?? 0

        return total
    }

}
