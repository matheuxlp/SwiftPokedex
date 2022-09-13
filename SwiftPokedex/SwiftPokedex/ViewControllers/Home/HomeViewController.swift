//
//  HomeViewController.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 23/08/22.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let pokeAPI = PokeAPI()
    var pokmeonsBasicInfo: [PokemonBasicInfo?] = []

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HomePokemonTableViewCell.self, forCellReuseIdentifier: HomePokemonTableViewCell().identifier)
        tableView.allowsSelection = true
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    let searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pokmeonsBasicInfo = pokeAPI.loadTenPokemons()
        self.addSubviews()
        self.setupConstraints()
    }

    private func addSubviews() {
        self.view.addSubview(self.tableView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

}

extension HomeViewController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pokmeonsBasicInfo.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
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
        return customCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = PokemonViewController()
        guard let pokeId = pokmeonsBasicInfo[indexPath.row]?.nationalNumber,
              let basicInfo = pokmeonsBasicInfo[indexPath.row]
        else {fatalError("god help me")}
        let aboutPkm = self.pokeAPI.getAbout(pokeId, basicInfo)
        let statsPkm = self.pokeAPI.getStats(pokeId, basicInfo)
        viewController.about = aboutPkm
        viewController.stats = statsPkm
        viewController.basicInfo = self.pokmeonsBasicInfo[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }

}
