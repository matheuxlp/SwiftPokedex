//
//  About.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 23/08/22.
//

import Foundation

class About {
    let flavorText: String?
    let pokedex: PokedexData
    let training: Training
    let breeding: Breeding
    let pokedexNumbers: [PokedexEntry]
    init(flavorText: String?, pokedex: PokedexData, training: Training,
         breeding: Breeding, pokedexNumbers: [PokedexEntry]) {
        self.flavorText = flavorText
        self.pokedex = pokedex
        self.training = training
        self.breeding = breeding
        self.pokedexNumbers = pokedexNumbers
    }
}

struct Ability {
    let name: String?
    let isHidden: Bool?
    let slot: Int?
}

struct PokedexData {
    let species: String?  // pokemon
    let height: Int?  // pokemon
    let weight: Int?  // pokemon
    let abilities: [Ability]?  // pokemon
    let weaknesses: [String]?  // pokemon
}

struct EffortValue {
    let name: String?
    let value: Int?
}

struct Training {
    let EVYield: [EffortValue]  // pokemon
    let catchRate: Int?  // species
    let baseFriendship: Int?  // species
    let baseExp: Int?  // pokemon
    let growthRate: String?  // species
}
struct Breeding {
    let gender: Int?  // species | n/8
    let eggGroups: [String?]  // species
    let eggCycles: Int?  // species
}

struct PokedexEntry {
    let generation: PokedexGame?
    let number: Int?
}

// swiftlint:disable all
enum PokedexGame: String {
    case rby = "(Red/Blue/Yellow)"
    case gsc = "(Gold/Silver/Crystal)"
    case frlg = "(FireRed/LeafGreen)"
    case hgss = "(HeartGold/SoulSilver)"
    case xy = "(X/Y - Central Kalos)"
    case lgplge = "(Let's Go Pikachu/Let's Go Eevee)"
    case ss = "(Sword/Shield)"
}
// swiftlint:enable all
