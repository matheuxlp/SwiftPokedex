//
//  PokemonAboutLabelsTableViewCell.swift
 //  SwiftPokedex
//
//  Created by Matheus Polonia on 24/08/22.
//

import UIKit
import Foundation

class PokemonAboutLabelsTableViewCell: UITableViewCell {

    let identifier: String = "PokemonAboutLabelsCell"

    var data: Any?
    var infoType: AboutPokemonInfoType?
    var row: Int?
    var text: String?
    var color: UIColor?

    internal let dataTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    internal let firstInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    internal let secondInfoSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    internal let infoLabelsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.spacing = 0
        stackView.backgroundColor = .clear
        return stackView
    }()

    internal let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.backgroundColor = .clear
        return stackView
    }()

    internal func addSubviews() {
        self.contentView.addSubview(self.cellStackView)

        self.cellStackView.addArrangedSubview(self.dataTitleLabel)
        self.cellStackView.addArrangedSubview(self.infoLabelsStack)

        self.infoLabelsStack.addArrangedSubview(self.firstInfoLabel)
        self.infoLabelsStack.addArrangedSubview(self.secondInfoSubLabel)
    }

    internal func setupConstraints() {
        NSLayoutConstraint.activate([
            self.cellStackView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.cellStackView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            self.cellStackView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            self.cellStackView.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),

            self.dataTitleLabel.leadingAnchor.constraint(equalTo: self.cellStackView.layoutMarginsGuide.leadingAnchor),
            self.dataTitleLabel.topAnchor.constraint(equalTo: self.cellStackView.layoutMarginsGuide.topAnchor),
            self.dataTitleLabel.bottomAnchor.constraint(equalTo: self.cellStackView.layoutMarginsGuide.bottomAnchor),

            self.infoLabelsStack.leadingAnchor.constraint(equalTo: self.dataTitleLabel.trailingAnchor),
            self.infoLabelsStack.topAnchor.constraint(equalTo: self.cellStackView.topAnchor),
            self.infoLabelsStack.trailingAnchor.constraint(equalTo: self.cellStackView.trailingAnchor),
            self.infoLabelsStack.bottomAnchor.constraint(equalTo: self.cellStackView.bottomAnchor)
        ])
    }

    override func prepareForReuse() {
        self.row = 1
        self.dataTitleLabel.text = ""
        self.dataTitleLabel.font = .systemFont(ofSize: 17)
        self.dataTitleLabel.textColor = .black
        self.firstInfoLabel.text = ""
        self.firstInfoLabel.font = .systemFont(ofSize: 17)
        self.firstInfoLabel.textColor = .black
        self.infoLabelsStack.isHidden = false
        self.infoLabelsStack.axis = .vertical
    }

    func setupData() {
        self.addSubviews()
        self.setupConstraints()
        self.secondInfoSubLabel.isHidden = true
        if row ?? -1 == 0 && infoType != .flavorText {
            self.dataTitleLabel.textAlignment = .left
            self.dataTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
            self.dataTitleLabel.textColor = color ?? .black
            self.dataTitleLabel.text = text ?? ""
            self.dataTitleLabel.numberOfLines = 0
            self.infoLabelsStack.isHidden = true
        } else {
            switch infoType {
            case .flavorText:
                self.setupFlavorText()
            case .pokedexData:
                self.setupPokedexData()
            case .training:
                self.setupTraining()
            case .breeding:
                self.setupBreeding()
            case .numbers:
                self.setupNumers()
            default:
                self.dataTitleLabel.text = "Title"
                self.firstInfoLabel.text = "First"
            }
        }
    }

    fileprivate func setupFlavorText() {
        self.dataTitleLabel.textAlignment = .left
        self.dataTitleLabel.font = .systemFont(ofSize: 16)
        self.dataTitleLabel.text = self.getFlavorText(text ?? "")
        self.dataTitleLabel.numberOfLines = 0
        self.dataTitleLabel.lineBreakMode = .byClipping
        self.infoLabelsStack.isHidden = true
    }

    fileprivate func setupNumers() {
        guard let data = data as? [PokedexEntry] else { return }
        self.dataTitleLabel.text = String(format: "%03d", data[row ?? 0].number ?? 0)
        self.firstInfoLabel.text = data[row ?? 0].generation?.rawValue
        self.firstInfoLabel.font = .systemFont(ofSize: 14)
        self.firstInfoLabel.textColor = .systemGray
    }

    fileprivate func showSecondLabelSide() {
        self.infoLabelsStack.axis = .horizontal
        self.infoLabelsStack.alignment = .center
        self.infoLabelsStack.distribution = .fillEqually
        self.secondInfoSubLabel.isHidden = false
    }

    fileprivate func setupBreeding() {
        guard let data = data as? Breeding else { return }
        switch row {
        case 1:
            self.showSecondLabelSide()
            self.dataTitleLabel.text = "Gender"
            let genderChance = self.genderRatio(data.gender ?? 0)
            self.firstInfoLabel.text = "♂\(genderChance.0)%"
            self.firstInfoLabel.textColor = .systemBlue
            self.secondInfoSubLabel.text = "♀\(genderChance.1)%"
            self.secondInfoSubLabel.textColor = .systemPink
        case 2:
            self.dataTitleLabel.text = "Egg Groups"
            var eggGroups: String = ""
            for eggGroup in data.eggGroups {
                eggGroups += eggGroup?.capitalizingFirstLetter() ?? ""
                eggGroups += ", "
            }
            eggGroups.removeLast()
            eggGroups.removeLast()
            self.firstInfoLabel.text = "\(eggGroups)"
        case 3:
            self.showSecondLabelSide()
            self.infoLabelsStack.alignment = .leading
            self.infoLabelsStack.distribution = .fill
            self.dataTitleLabel.text = "Egg Cycles"
            self.firstInfoLabel.text = "\(data.eggCycles ?? 0) "
            self.secondInfoSubLabel.text = "(\((data.eggCycles ?? 0) * 257) steps)"
        default:
            return
        }
    }

    fileprivate func setupTraining() {
        guard let data = data as? Training else { return }
        switch row {
        case 1:
            self.dataTitleLabel.text = "EV Yield"
            self.firstInfoLabel.text = self.createEVString(data.EVYield)
        case 2:
            self.dataTitleLabel.text = "Catch Rate"
            self.firstInfoLabel.text = "\(data.catchRate ?? 0)"
        case 3:
            self.showSecondLabelSide()
            self.infoLabelsStack.alignment = .leading
            self.infoLabelsStack.distribution = .fill
            self.dataTitleLabel.text = "Base Friendship"
            self.firstInfoLabel.text = "\(data.baseFriendship ?? 0)"
            let baseFriendShip = data.baseFriendship ?? 0
            switch baseFriendShip {
            case _ where baseFriendShip == 50:
                self.secondInfoSubLabel.text = "(Normal)"
            case _ where baseFriendShip > 50:
                self.secondInfoSubLabel.text = "(High)"
            default:
                self.secondInfoSubLabel.text = "(Low)"
            }
        case 4:
            self.dataTitleLabel.text = "Base Exp"
            self.firstInfoLabel.text = "\(data.baseExp ?? 0)"
        case 5:
            self.dataTitleLabel.text = "Growth Rate"
            let strings = data.growthRate?.split(separator: "-") ?? []
            self.firstInfoLabel.text = "\(String.init(strings[0]).capitalizingFirstLetter()) "
            + "\(strings.count > 1 ? String.init(strings[1]).capitalizingFirstLetter() : "")"
        default:
            return
        }
    }

    fileprivate func setupPokedexData() {
        guard let data = data as? PokedexData else { return }
        switch row {
        case 1:
            self.dataTitleLabel.text = "Species"
            self.firstInfoLabel.text = data.species?.capitalizingFirstLetter() ?? "species"
        case 2:
            self.dataTitleLabel.text = "Height"
            self.firstInfoLabel.text = "\(data.height ?? 0)m"
        case 3:
            self.dataTitleLabel.text = "Weight"
            self.firstInfoLabel.text = "\(data.weight ?? 0)kg"
        case 4:
            self.secondInfoSubLabel.isHidden = false
            let abilitiesStrings = self.createAbilitiesString(data.abilities)

            self.dataTitleLabel.text = "Abilities"
            self.firstInfoLabel.text = abilitiesStrings.0
            if abilitiesStrings.1.isEmpty {
                self.secondInfoSubLabel.isHidden = true
            } else {
                self.secondInfoSubLabel.text = abilitiesStrings.1
            }
        case 5:
            self.setupWeaknessess(data)
        default:
            return
        }
    }

    fileprivate func setupWeaknessess(_ data: PokedexData) {
        self.dataTitleLabel.text = "Weaknessess"
        let fullString = NSMutableAttributedString(string: "")

        for weaknesses in data.weaknesses ?? [] {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(named: "badge.\(weaknesses)")!
                .imageWithSpacing(insets: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))!
                .withBackground(color: UIColor(named: "type.\(weaknesses)")!)
                .withRoundedCornersSize(cornerRadius: 4)
            let imageString = NSAttributedString(attachment: imageAttachment)
            fullString.append(imageString)
            fullString.append(NSAttributedString(string: "  "))
        }

        self.firstInfoLabel.attributedText = fullString
        self.firstInfoLabel.numberOfLines = 0
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    fileprivate func createAbilitiesString(_ abilities: [Ability]?) -> (String, String) {
        var abilitiesString: String = ""
        var hiddenAbilitiesString: String = ""
        if let abilities = abilities {
            for ability in abilities {
                if let isHidden = ability.isHidden {
                    if isHidden {
                        hiddenAbilitiesString += "\(ability.name?.capitalizingFirstLetter() ?? "") (hidden ability) \n"
                    } else {
                        abilitiesString += "\(ability.slot ?? 0). \(ability.name?.capitalizingFirstLetter() ?? "")\n"
                    }
                }
            }
        }
        abilitiesString.removeLast()
        abilitiesString.removeLast()
        if hiddenAbilitiesString.isEmpty == false {
            hiddenAbilitiesString.removeLast()
            hiddenAbilitiesString.removeLast()
        }
        return (abilitiesString, hiddenAbilitiesString)
    }

    fileprivate func createEVString(_ evData: [EffortValue]) -> String {
        var finalString: String = ""
        for evInfo in evData {
            let nameParts = evInfo.name?.split(separator: "-") ?? []
            var finalName = ""
            var counter = 1
            for part in nameParts {
                finalName += "\(part)  ".capitalizingFirstLetter()
                if counter != nameParts.count {
                    finalName.removeLast()
                }
                counter += 1
            }
            finalString += "\(evInfo.value ?? -1) \(finalName)\n"
        }
        finalString.removeLast()
        finalString.removeLast()
        return finalString
    }

    fileprivate func genderRatio(_ val: Int) -> (Double, Double) {
        var maleChance: Double = 0
        var femaleChance: Double = 0

        if val == -1 {
            return (100, 0)
        }

        femaleChance = Double(val) / 8
        maleChance = 1 - femaleChance

        return (maleChance * 100, femaleChance * 100)
    }

    fileprivate func getFlavorText(_ toChange: String) -> String {
        let array = toChange.split(separator: "\n")
        var newOne: String = ""
        for word in array {
            newOne += "\(word) "
        }
        return newOne
    }

}

extension UIImage {
    func withBackground(color: UIColor, opaque: Bool = true) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size.width * 1.5, height: size.height * 1.5),
                                               opaque,
                                               scale)

        guard let ctx = UIGraphicsGetCurrentContext(),
              let image = cgImage
        else { return self }
        defer { UIGraphicsEndImageContext() }

        let rect = CGRect(origin: .zero, size: CGSize(width: size.width * 1.5, height: size.height * 1.5))
        ctx.setFillColor(color.cgColor)
        ctx.fill(rect)
        ctx.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height * 1.5))
        ctx.draw(image, in: rect)

        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }

    func withRoundedCornersSize(cornerRadius: Float) -> UIImage? {
        let imageView = UIImageView(image: self)
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, 1.0)
        UIBezierPath(roundedRect: imageView.bounds, cornerRadius: CGFloat(cornerRadius)).addClip()
        self.draw(in: imageView.bounds)
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageView.image
    }

    func imageWithSpacing(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
}
