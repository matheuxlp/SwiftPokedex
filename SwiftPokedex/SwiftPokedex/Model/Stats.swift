//
//  Stats.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 23/08/22.
//

import Foundation

class Stats {
    let baseStats: BaseStats?
    let minStats: MinimumStats?
    let maxSatas: MaximumStats?
    let defenses: [TypeRelationDamage]

    init(base: BaseStats, min: MinimumStats, max: MaximumStats, defense: [TypeRelationDamage]) {
        self.baseStats = base
        self.minStats = min
        self.maxSatas = max
        self.defenses = defense
    }
}

protocol StatsProtocol {
    var healthPoints: Int? {get}
    var attack: Int? {get}
    var defense: Int? {get}
    var specialAttack: Int? {get}
    var specialDefense: Int? {get}
    var speed: Int? {get}
}

struct BaseStats: StatsProtocol {
    var healthPoints: Int?
    var attack: Int?
    var defense: Int?
    var specialAttack: Int?
    var specialDefense: Int?
    var speed: Int?

}

struct MinimumStats: StatsProtocol {
    var healthPoints: Int?
    var attack: Int?
    var defense: Int?
    var specialAttack: Int?
    var specialDefense: Int?
    var speed: Int?

}

struct MaximumStats: StatsProtocol {
    var healthPoints: Int?
    var attack: Int?
    var defense: Int?
    var specialAttack: Int?
    var specialDefense: Int?
    var speed: Int?

}

struct TypeRelationDamage {
    let name: String
    var relation: String
}
