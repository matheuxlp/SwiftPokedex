//
//  PokemonAboutLabelsTableViewCell.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 24/08/22.
//

import UIKit
import Foundation

class PokemonAboutLabelsTableViewCell: UITableViewCell {

    var data: Any?
    var infoType: AboutPokemonInfoType?
    var row: Int?
    var text: String?
    var color: UIColor?

    @IBOutlet weak var dataTitleLabel: UILabel!
    @IBOutlet weak var firstInfoLabel: UILabel!
    @IBOutlet weak var firstInfoSubLabel: UILabel!

    @IBOutlet weak var infoLabelsStack: UIStackView!

    override func prepareForReuse() {
        self.row = 1
        self.dataTitleLabel.text = ""
        self.dataTitleLabel.font = .systemFont(ofSize: 17)
        self.dataTitleLabel.textColor = .black
        self.firstInfoLabel.text = ""
        self.firstInfoLabel.font = .systemFont(ofSize: 17)
        self.firstInfoLabel.textColor = .black
        self.infoLabelsStack.isHidden = false
    }

    func setupData() {
        self.firstInfoSubLabel.isHidden = true
        if row ?? -1 == 0 && infoType != .flavorText {
            self.dataTitleLabel.textAlignment = .left
            self.dataTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
            self.dataTitleLabel.textColor = color ?? .black
            self.dataTitleLabel.text = text ?? ""
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

    fileprivate func setupBreeding() {
        guard let data = data as? Breeding else { return }
        switch row {
        case 1:
            self.dataTitleLabel.text = "Gender"
            let genderChance = self.genderRatio(data.gender ?? 0)
            self.firstInfoLabel.text = "♂\(genderChance.0)%, ♀\(genderChance.1)%"
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
            self.dataTitleLabel.text = "Egg Cycles"
            self.firstInfoLabel.text = "\(data.eggCycles ?? 0) (\((data.eggCycles ?? 0) * 257) steps)"
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
            self.dataTitleLabel.text = "Base Friendship"
            self.firstInfoLabel.text = "\(data.baseFriendship ?? 0)"
        case 4:
            self.dataTitleLabel.text = "Base Exp"
            self.firstInfoLabel.text = "\(data.baseExp ?? 0)"
        case 5:
            self.dataTitleLabel.text = "Growth Rate"
            self.firstInfoLabel.text = "\(data.growthRate?.replacingOccurrences(of: "-", with: " ") ?? "nil")"
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
            self.firstInfoSubLabel.isHidden = false
            let abilitiesStrings = self.createAbilitiesString(data.abilities)

            self.dataTitleLabel.text = "Abilities"
            self.firstInfoLabel.text = abilitiesStrings.0
            if abilitiesStrings.1.isEmpty {
                self.firstInfoSubLabel.isHidden = true
            } else {
                self.firstInfoSubLabel.text = abilitiesStrings.1
            }
        default:
            return
        }
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
