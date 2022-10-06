//
//  BasicInfo.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 23/08/22.
//

import Foundation

struct PokemonBasicInfo: Codable {
    let nationalNumber: Int?
    let name: String?
    let height: Int?
    let weight: Int?
    let types: [String]
    let weaknesses: [String]
    let artUrl: String?
}
