//
//  HomeViewController.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 23/08/22.
//

import UIKit

class HomeViewController: UIViewController {

    let pokeAPI = PokeAPI()
    var pokmeonsBasicInfo: [PokemonBasicInfo?] = []

    @IBOutlet weak var tableView: UITableView!

    let searchController = UISearchController()

    let tableViewData = Array(repeating: "Item", count: 20)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.pokmeonsBasicInfo = pokeAPI.loadTenPokemons()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        searchController.automaticallyShowsCancelButton = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController

        let button1 = UIBarButtonItem(image: UIImage(systemName: "square"), style: .plain,
                                      target: self, action: #selector(self.showFilters(sender:)))
        self.navigationItem.rightBarButtonItem  = button1
    }

    // filtersView
    @objc func showFilters(sender: UIButton) {
        performSegue(withIdentifier: "filtersView", sender: nil)
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Code Here
        return self.pokmeonsBasicInfo.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokeBasicInfo = pokmeonsBasicInfo[indexPath.row]

        let identifier = "HomePokemonTableViewCell"
        guard let customCell = self.tableView.dequeueReusableCell(withIdentifier: identifier,
                                                                  for: indexPath) as? HomePokemonTableViewCell
        else {
            fatalError("There should be a cell with \(identifier) identifier.")
        }
        customCell.pokemon = pokeBasicInfo
        customCell.setupData()
        let bgColorView = UIView()
        bgColorView.backgroundColor = .clear
        customCell.selectedBackgroundView = bgColorView

        return customCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "pokemonViewSegue", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pokemonViewSegue" {
            guard let indexPath = sender as? IndexPath else {fatalError("IndexPath not found")}
            let pkmnVC = segue.destination as? PokemonViewController
            guard let pokeId = pokmeonsBasicInfo[indexPath.row]?.nationalNumber,
                  let basicInfo = pokmeonsBasicInfo[indexPath.row]
            else {fatalError("god help me")}
            let aboutPkm = self.pokeAPI.getAbout(pokeId, basicInfo)
            pkmnVC?.about = aboutPkm
            pkmnVC?.basicInfo = self.pokmeonsBasicInfo[indexPath.row]

        }
    }

}

