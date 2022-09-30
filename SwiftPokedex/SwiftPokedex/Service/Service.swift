//
//  Service.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 23/08/22.
//

import Foundation

class PokeAPI {

    private func requestData(_ url: URL, _ dataType: DataType, completionHandler: @escaping ([String: Any]) -> Void) {
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            // typealias PokemonData = [String:Any]
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
                  let recivedPokemon = json as? [String: Any]
            else {
                // completionHandler(BasicPokemonInfo())
                return
            }
            completionHandler(recivedPokemon)
            semaphore.signal()
        }
        .resume()
        _ = semaphore.wait(wallTimeout: .distantFuture)
    }

    func loadData(_ identifier: Int, dataType: DataType) -> [String: Any] {
        var requestedData: [String: Any] = [:]
        if identifier < 0 {
            print("Value must be bigger then zero")
            fatalError("Value must be bigger then zero")
        }
        guard let url = URL(string: ("https://pokeapi.co/api/v2/\(dataType.rawValue)/\(identifier)")) else {
            fatalError("URL not found")
        }
        self.requestData(url, dataType) { data in
            requestedData = data
        }
        return requestedData
    }

    func loadData(_ name: String, dataType: DataType) -> [String: Any] {
        var requestedData: [String: Any] = [:]
        if name == "" {
            print("Value must be bigger then zero")
            fatalError("Value must be bigger then zero")
        }
        guard let url = URL(string: ("https://pokeapi.co/api/v2/\(dataType.rawValue)/\(name)")) else {
            fatalError("URL not found")
        }
        self.requestData(url, dataType) { data in
            requestedData = data
        }
        return requestedData
    }
}

// MARK: - LoadData

extension PokeAPI {

    public func loadPokemons(totalLoaded: Int = 0) -> [PokemonBasicInfo] {
        var pokes: [PokemonBasicInfo] = []
        for pokeId in (totalLoaded + 1)...(totalLoaded + 29) {
            if let poke = self.getBasicInfo(identifier: pokeId) {
                pokes.append(poke)
            }
        }
        return pokes
    }

    public func loadPokemons(nameFilter: String = "", idFilter: String = "", totalLoaded: Int = 0, lastId: Int = 0) -> [PokemonBasicInfo] {
        print(idFilter)
        var pokes: [PokemonBasicInfo] = []
        var countToLoad = 30 - totalLoaded
        var pokeId = lastId + 1
        while countToLoad != 0 {
            if pokeId > 905 {
                break
            }
            if let poke = self.getBasicInfo(identifier: pokeId) {
                if "\(poke.nationalNumber ?? -1)".contains(idFilter) {
                    countToLoad -= 1
                    pokes.append(poke)
                    pokeId += Int(idFilter) ?? 1
                    continue
                } else if (poke.name ?? "").contains(nameFilter.lowercased()) {
                    countToLoad -= 1
                    pokes.append(poke)
                }
            }
            pokeId += 1
        }
        return pokes
    }
}

// MARK: - Helper Functions

extension PokeAPI {

    private func getWeaknesses(_ types: [String]) -> [String]? {
        var weaknesses: [String] = []
        var halfDamageFrom: [String] = []
        var doubleDamageFrom: [String] = []
        for type in types {
            let typeData = self.loadData(type, dataType: .type)
            guard let damageRelations = typeData["damage_relations"] as? [String: Any],
                  let HDFData = damageRelations["half_damage_from"] as? [[String: Any]],
                  let DDFData = damageRelations["double_damage_from"] as? [[String: Any]]
            else {return nil}
            for HDFItem in HDFData {
                guard let name = HDFItem["name"] as? String else {return nil}
                halfDamageFrom.append(name)
            }
            for DDFItem in DDFData {
                guard let name = DDFItem["name"] as? String else {return nil}
                doubleDamageFrom.append(name)
            }
        }
        for doubleDamage in doubleDamageFrom {
            if !halfDamageFrom.contains(where: {$0 == doubleDamage}) {
                weaknesses.append(doubleDamage)
            }
        }
        return weaknesses
    }

    func getPokedexEntry(_ speciesName: String, _ pokedexData: [String: Any]) -> PokedexEntry? {
        let identification = pokedexData["id"] as? Int ?? -1
        let entries = pokedexData["pokemon_entries"] as? [[String: Any]] ?? [[:]]
        for pokemonEntry in entries {
            let pokedexNumber = pokemonEntry["entry_number"] as? Int
            let pokemonSpecies = pokemonEntry["pokemon_species"] as? [String: Any] ?? [:]
            let name = pokemonSpecies["name"] as? String ?? ""
            if name == speciesName {
                switch identification {
                case 2: // red/fireRed
                    let entry = PokedexEntry(generation: .rby, number: pokedexNumber)
                    return entry
                case 3: // gold
                    let entry = PokedexEntry(generation: .gsc, number: pokedexNumber)
                    return entry
                case 7: // hearthgold
                    let entry = PokedexEntry(generation: .hgss, number: pokedexNumber)
                    return entry
                case 12: // central kalos
                    let entry = PokedexEntry(generation: .xy, number: pokedexNumber)
                    return entry
                case 26: // lets go
                    let entry = PokedexEntry(generation: .lgplge, number: pokedexNumber)
                    return entry
                case 27: // sword
                    let entry = PokedexEntry(generation: .ss, number: pokedexNumber)
                    return entry
                default:
                    return nil
                }
            }

        }
        return nil
    }

    func maxStatCalculation(_ statValue: Int?) -> Int? {
        if statValue != nil {
            return Int((Double(statValue!) * 2.0 + 99.0) * 1.1)
        }
        return nil
    }

    func maxHealthCalculation(_ statValue: Int?) -> Int? {
        if statValue != nil {
            return statValue! * 2 + 204
        }
        return nil
    }

    func minStatCalculation(_ statValue: Int?) -> Int? {
        if statValue != nil {
            return Int((Double(statValue!) * 2.0 + 5.0) * 0.9)
        }
        return nil
    }

    func minHealthCalculation(_ statValue: Int?) -> Int? {
        if statValue != nil {
            return statValue! * 2 + 110
        }
        return nil
    }

}

// MARK: - Basic Information Section

extension PokeAPI {

    func getArtURL(_ data: [String: Any]) -> String? {
        if let otherData = data["other"] as? [String: Any] {
            if let officialArt = otherData["official-artwork"] as? [String: Any] {
                if let url = officialArt["front_default"] as? String {
                    return url
                }
            }
        }
        return nil
    }

    func getBasicInfo(identifier: Int) -> PokemonBasicInfo? {
        let pokemonData: [String: Any] = self.loadData(identifier, dataType: .pokemon)
        // guard
        let number = pokemonData["id"] as? Int
        let name = pokemonData["name"] as? String
        let height = pokemonData["height"] as? Int
        let weight = pokemonData["weight"] as? Int
        let typesInfo = pokemonData["types"] as? [[String: Any]] ?? []
        var types: [String] = []
        for typeInfo in typesInfo {
            guard let type = typeInfo["type"] as? [String: Any],
                  let name = type["name"] as? String
            else {return nil}
            types.append(name)
        }
        let artURL: String? = self.getArtURL(pokemonData["sprites"] as? [String: Any] ?? [:])
        guard let weaknesses = self.getWeaknesses(types) else {return nil}
        let basicInfo: PokemonBasicInfo = PokemonBasicInfo(nationalNumber: number, name: name, height: height,
                                                           weight: weight, types: types,
                                                           weaknesses: weaknesses, artUrl: artURL)
        return basicInfo
    }
}

// MARK: - About Section

extension PokeAPI {
//    private func getGenera(_ identifier: Int) {
//        print("got here")
//        let speciesData = self.loadData(identifier, dataType: .species)
//        if let genera = speciesData["genera"] as? [[String: Any]] {
//            for entry in genera {
//                if let languageData = entry as? [String: Any] {
//                    if let languageName = languageData["name"] as? String {
//                        if languageName == "en" {
//                            print("yeah")
//                        }
//                    }
//                }
//            }
//        }
//    }

    private func getPokedexData(_ basicInfo: PokemonBasicInfo, _ pokemonData: [String: Any]) -> PokedexData {
        let abilitiesData = pokemonData["abilities"] as? [[String: Any]] ?? [[:]]
        var abilities: [Ability] = []
        for abilityData in abilitiesData {
            let isHidden = abilityData["is_hidden"] as? Int
            let slot = abilityData["slot"] as?  Int
            let abilityInfo = abilityData["ability"] as? [String: Any] ?? [:]
            let name = abilityInfo["name"] as? String
            abilities.append(Ability(name: name, isHidden: (isHidden == 0 ? false : true), slot: slot))
        }
//        self.getGenera(basicInfo.nationalNumber ?? -1)
        let speciesInfo = pokemonData["species"] as? [String: Any] ?? [:]
        let species = speciesInfo["name"] as? String
        let pokedexData = PokedexData(species: species, height: basicInfo.height, weight: basicInfo.weight,
                                      abilities: abilities, weaknesses: basicInfo.weaknesses)
        return pokedexData
    }
    private func getTraining(_ pokemonData: [String: Any], _ speciesData: [String: Any]) -> Training {
        var effortValues: [EffortValue] = []
        let statsData = pokemonData["stats"] as? [[String: Any]] ?? [[:]]
        for statInfo in statsData {
            let stat = statInfo["stat"] as? [String: Any] ?? [:]
            let name = stat["name"] as? String
            let value = statInfo["effort"] as? Int
            if value ?? 0 > 0 {
                effortValues.append(EffortValue(name: name, value: value))
            }
        }
        let baseExp = pokemonData["base_experience"] as? Int
        let catchRate = speciesData["capture_rate"] as? Int
        let baseFriendship = speciesData["base_happiness"] as? Int
        let growthInfo = speciesData["growth_rate"] as? [String: Any] ?? [:]
        let growth = growthInfo["name"] as? String
        let training = Training(EVYield: effortValues, catchRate: catchRate,
                                baseFriendship: baseFriendship, baseExp: baseExp, growthRate: growth)
        return training
    }

    private func getBreeding(_ speciesData: [String: Any]) -> Breeding {
        var eggGroups: [String?] = []
        let genderRate = speciesData["gender_rate"] as? Int
        let eggGroupInfo = speciesData["egg_groups"] as? [[String: Any]] ?? []
        for eggGroup in eggGroupInfo {
            let name = eggGroup["name"] as? String
            eggGroups.append(name)
        }
        let eggCycles = speciesData["hatch_counter"] as? Int
        let breeding = Breeding(gender: genderRate, eggGroups: eggGroups, eggCycles: eggCycles)
        return breeding
    }

    func getPokdexes(_ speciesName: String) -> [PokedexEntry] {
        let pokedexesIdentification = [2, 3, 7, 12, 26, 27]
        var entries: [PokedexEntry] = []
        for pokedexId in pokedexesIdentification {
            let pokedexData = loadData(pokedexId, dataType: .pokedex)
            if let entry = self.getPokedexEntry(speciesName, pokedexData) {
                entries.append(entry)
                if pokedexId == 2 {
                    let remakeEntry = PokedexEntry(generation: .frlg, number: entry.number)
                    entries.append(remakeEntry)
                }
            }
        }
        return entries
    }

    func getFlavorText(_ natinalDexNumber: Int, _ flavorTextEntries: [[String: Any]]) -> String? {
        for textEntry in flavorTextEntries {
            let versionData = textEntry["version"] as? [String: Any]
            let languageData = textEntry["language"] as? [String: Any]
            if let versionName = versionData?["name"] as? String {
                if let languageName = languageData?["name"] as? String {
                    if natinalDexNumber >= 720 {
                        if versionName == "sword" && languageName == "en" {
                            let flavorTex = textEntry["flavor_text"] as? String
                            return flavorTex
                        }
                    } else {
                        if versionName == "omega-ruby" && languageName == "en" {
                            let flavorTex = textEntry["flavor_text"] as? String
                            return flavorTex
                        }
                    }
                }
            }
        }
        return nil
    }

    // swiftlint:disable force_cast
    func getAbout(_ identifier: Int, _ basicInfo: PokemonBasicInfo) -> About {
        let pokemonData = self.loadData(identifier, dataType: .pokemon)
        let speciesData = self.loadData(identifier, dataType: .species)
        //        var species: String?
        //        if let speciesInfo = pokemonData["species"] as? [String:Any] {
        //            species = speciesInfo["name"] as? String
        //        }
        let pokedexData = self.getPokedexData(basicInfo, pokemonData)
        let training = self.getTraining(pokemonData, speciesData)
        let breeding = self.getBreeding(speciesData)
        let entries = self.getPokdexes(pokedexData.species ?? "")
        let flavorTex = self.getFlavorText(basicInfo.nationalNumber!,
                                           speciesData["flavor_text_entries"] as! [[String: Any]])
        let about = About(flavorText: flavorTex, pokedex: pokedexData,
                          training: training, breeding: breeding, pokedexNumbers: entries)
        return about
        // print(about.pokedexNumbers)
    }
    // swiftlint:enable force_cast
}

// MARK: - Stats Section

extension PokeAPI {
    func getBaseStats(_ pokemonStats: [[String: Any]]) -> BaseStats {
        var baseStats: [String: Int?] = [:]
        for statData in pokemonStats {
            let baseStat = statData["base_stat"] as? Int
            let statNameData = statData["stat"] as? [String: Any]
            if let statName = statNameData?["name"] as? String {
                baseStats[statName] = baseStat
            }
        }
        let base = BaseStats(healthPoints: baseStats["hp"] ?? nil,
                             attack: baseStats["attack"] ?? nil,
                             defense: baseStats["defense"] ?? nil,
                             specialAttack: baseStats["special-attack"] ?? nil,
                             specialDefense: baseStats["special-defense"] ?? nil,
                             speed: baseStats["speed"] ?? nil)
        return base
    }

    func getMaxStats(_ baseStats: BaseStats) -> MaximumStats {
        let max = MaximumStats(healthPoints: maxHealthCalculation(baseStats.healthPoints ?? nil),
                               attack: maxStatCalculation(baseStats.attack ?? nil),
                               defense: maxStatCalculation(baseStats.defense ?? nil),
                               specialAttack: maxStatCalculation(baseStats.specialAttack ?? nil),
                               specialDefense: maxStatCalculation(baseStats.specialDefense ?? nil),
                               speed: maxStatCalculation(baseStats.speed ?? nil))
        return max
    }

    func getMinStats(_ baseStats: BaseStats) -> MinimumStats {
        let min = MinimumStats(healthPoints: minHealthCalculation(baseStats.healthPoints ?? nil),
                               attack: minStatCalculation(baseStats.attack ?? nil),
                               defense: minStatCalculation(baseStats.defense ?? nil),
                               specialAttack: minStatCalculation(baseStats.specialAttack ?? nil),
                               specialDefense: minStatCalculation(baseStats.specialDefense ?? nil),
                               speed: minStatCalculation(baseStats.speed ?? nil))
        return min
    }

    func typeRelationComparator(ty1: String, ty2: String) -> String {
        switch (ty1, ty2) {
        case ("half_damage_from", "half_damage_from"):
            return "quarter_damage_from"
        case ("double_damage_from", "double_damage_from"):
            return "double_damage_from"
        case ("no_damage_from", "no_damage_from"):
            return "no_damage_from"
        case ("half_damage_from", "double_damage_from"):
            return "normal_damage_from"
        case ("double_damage_from", "half_damage_from"):
            return "normal_damage_from"
        case ("half_damage_from", "no_damage_from"):
            return "no_damage_from"
        case ("no_damage_from", "half_damage_from"):
            return "no_damage_from"
        default:
            print("error")
        }
        return "error"
    }

    func pkmnDefense(_ typesInfo: [[String: String]]) -> [TypeRelationDamage] {
        let firstType = typesInfo[0]
        let secondType: [String: String] = typesInfo.count > 1 ? typesInfo[1] : [:]
        var defenseInfo: [TypeRelationDamage] = []
        for typeDefenseInfo in firstType {
            if secondType.contains(where: {$0.key == typeDefenseInfo.key}) {
                let result = self.typeRelationComparator(ty1: typeDefenseInfo.value,
                                                         ty2: secondType[typeDefenseInfo.key]!)
                defenseInfo.append(TypeRelationDamage(name: typeDefenseInfo.key, relation: result))
            } else {
                defenseInfo.append(TypeRelationDamage(name: typeDefenseInfo.key, relation: typeDefenseInfo.value))
            }
        }
        return defenseInfo
    }

    func damageRelations(_ types: [String]) -> [TypeRelationDamage] {
        var damageRelations: [[String: String]] = []
        for pkmType in types {
            var info: [String: String] = [:]
            let pkmTypeData = self.loadData(pkmType, dataType: .type)
            if let damageRelationsData = pkmTypeData["damage_relations"] as? [String: Any] {
                for damageRelationData in damageRelationsData {
                    if let relationData = damageRelationsData[damageRelationData.key] as? [[String: Any]] {
                        for rlt in relationData {
                            // print("NAME: \(damageRelationData.key)")
                            if let rltName = rlt["name"] as? String {
                                // print(rltName)
                                // print(type(of: Types.init(rawValue: rltName)))
                                if damageRelationData.key.last == "m" {
                                    // info.append(TypeRelationDamage(name: rltName, relation: damageRelationData.key))
                                    info[rltName] = damageRelationData.key
                                }
                            }
                        }
                    }
                }
            }
            damageRelations.append(info)
        }
        return self.pkmnDefense(damageRelations)
        // print(damageRelations.count)
        // print(damageRelations)
    }

    func getStats(_ identifier: Int, _ basicInfo: PokemonBasicInfo) -> Stats {
        let pokemonData = self.loadData(identifier, dataType: .pokemon)
        // let speciesData = self.loadData(identifier, dataType: .species)
        // print(about.pokedexNumbers)
        let base = self.getBaseStats(pokemonData["stats"] as? [[String: Any]] ?? [[:]])
        let max = self.getMaxStats(base)
        let min = self.getMinStats(base)
        let defense = self.damageRelations(basicInfo.types)

        let stats = Stats(base: base, min: min, max: max, defense: defense)
        return stats
    }
}

// MARK: - Enums

extension PokeAPI {

    enum DataType: String {
        case pokemon = "pokemon"
        case type = "type"
        case species = "pokemon-species"
        case pokedex = "pokedex"
        case evolution = "evolution-chain"
    }

    enum DamageRelation: String {
        case doubleDamageFrom
        case doubleDamageTo
        case halfDamageFrom
        case halfDamageTo
        case noDamageFrom
        case noDamageTo
        case normalDamage
    }

    enum Types: String {
        case normal
        case fire
        case water
        case grass
        case electric
        case ice
        case fighting
        case poison
        case ground
        case flying
        case psychic
        case bug
        case rock
        case ghost
        case dark
        case dragon
        case steel
        case fairy
    }
}

