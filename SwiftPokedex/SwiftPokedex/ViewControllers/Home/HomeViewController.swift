//
//  HomeViewController.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 23/08/22.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let pokeAPI = PokeAPI()
    var pokemonsBasicInfo: [PokemonBasicInfo?] = []
    var filteredpokemonsBasicInfo: [PokemonBasicInfo?] = []

    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HomePokemonTableViewCell.self, forCellReuseIdentifier: HomePokemonTableViewCell().identifier)
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    let searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchController.searchBar.tintColor = .systemBlue
        self.hideKeyboardWhenTappedAround()
        self.fetchData()
        self.addSubviews()
        self.setupConstraints()
        self.setupNavigationBar()
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "What Pokémon are you looking for?"
        self.navigationItem.searchController = searchController
        self.searchController.isActive = true
        self.definesPresentationContext = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }

    func fetchData() {
        self.pokemonsBasicInfo = pokeAPI.getBasicInfo() ?? []
    }

    @objc func showFilters(sender: UIButton) {
        self.present(FiltersViewController(), animated: true, completion: nil)
    }

    @objc func showSort(sender: UIButton) {
        let viewControler = SortViewController()
        if let presentationController = viewControler.presentationController as? UISheetPresentationController {
                    presentationController.detents = [.medium()]
                }
        self.present(viewControler, animated: true, completion: nil)
    }

    @objc func showGenerations(sender: UIButton) {
        self.present(GenerationsViewController(), animated: true, completion: nil)
    }

    private func setupNavigationBar() {
        self.navigationItem.title = "Pokédex"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = .black
        let filterButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "slider.horizontal.3")?
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 22)), for: .normal)
            button.tintColor = .black
            button.addTarget(self, action: #selector(showFilters(sender:)), for: .touchUpInside)
            return button
        }()
        let sortButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "arrow.up.arrow.down")?
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 22)), for: .normal)
            button.tintColor = .black
            button.addTarget(self, action: #selector(showSort(sender:)), for: .touchUpInside)
            return button
        }()
        let generationButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "circle.grid.3x3.fill")?
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 22)), for: .normal)
            button.tintColor = .black
            button.addTarget(self, action: #selector(showGenerations(sender:)), for: .touchUpInside)
            return button
        }()
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = 10
            return stackView
        }()

        stackView.addArrangedSubview(filterButton)
        stackView.addArrangedSubview(sortButton)
        stackView.addArrangedSubview(generationButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackView)
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

    func filterContentForSearchText(_ searchText: String) {
        self.filteredpokemonsBasicInfo = self.pokemonsBasicInfo.filter { (pokemon: PokemonBasicInfo?) -> Bool in
            return pokemon?.name?.lowercased().contains(searchText.lowercased()) ?? false ||
            "\(pokemon?.nationalNumber ?? -1)".contains(searchText)
     }
//      tableView.reloadData()
    }

}

extension HomeViewController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredpokemonsBasicInfo.count
        }
        return self.pokemonsBasicInfo.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "HomePokemonTableViewCell"
        guard let customCell = self.tableView.dequeueReusableCell(withIdentifier: identifier,
                                                                  for: indexPath) as? HomePokemonTableViewCell
        else { fatalError("There should be a cell with \(identifier) identifier.") }
        let pokemon: PokemonBasicInfo?
          if isFiltering {
              pokemon = filteredpokemonsBasicInfo[indexPath.row]
          } else {
              pokemon = pokemonsBasicInfo[indexPath.row]
          }
        customCell.pokemon = pokemon
        customCell.setupData()
        return customCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.searchController.searchBar.isFirstResponder {
            self.searchController.searchBar.resignFirstResponder()
        } else {
            let viewController = PokemonViewController()
            var pokeId: Int?
            var basicInfo: PokemonBasicInfo?
            if isFiltering {
                pokeId = filteredpokemonsBasicInfo[indexPath.row]?.nationalNumber
                basicInfo = filteredpokemonsBasicInfo[indexPath.row]
            } else {
                pokeId = pokemonsBasicInfo[indexPath.row]?.nationalNumber
                basicInfo = pokemonsBasicInfo[indexPath.row]
            }
            viewController.pokeId = pokeId
            viewController.basicInfo = basicInfo
            self.navigationController?.pushViewController(viewController, animated: true)
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }

//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let lastElement = self.isFiltering ? self.filteredpokemonsBasicInfo.count : self.pokemonsBasicInfo.count
//        if indexPath.row == lastElement - 10 {
//            DispatchQueue.main.async {
//                if self.isFiltering && self.filteredpokemonsBasicInfo.count >= 30 {
//                    print("got filtering")
//                    let searchBar = self.searchController.searchBar
//                    if searchBar.text!.isInt {
//                        self.filteredpokemonsBasicInfo.append(contentsOf: self.pokeAPI.loadPokemons(idFilter: searchBar.text!,
//                      lastId: self.filteredpokemonsBasicInfo[self.filteredpokemonsBasicInfo.count - 1]?.nationalNumber ?? -1))
//                    } else {
//                        self.filteredpokemonsBasicInfo.append(contentsOf: self.pokeAPI.loadPokemons(nameFilter: searchBar.text!,
//                        lastId: self.filteredpokemonsBasicInfo[self.filteredpokemonsBasicInfo.count - 1]?.nationalNumber ?? -1))
//                    }
//                } else {
//                    self.pokemonsBasicInfo.append(contentsOf: self.pokeAPI.loadPokemons(totalLoaded: lastElement))
//                }
//                self.tableView.reloadData()
//            }
//        }
//    }

}

extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
  func updateSearchResults(for searchController: UISearchController) {
      let searchBar = searchController.searchBar
      self.filterContentForSearchText(searchBar.text!)
      if isFiltering && filteredpokemonsBasicInfo.count < 30 {
          print("here")
//          if searchBar.text!.isInt {
//              self.filteredpokemonsBasicInfo.append(contentsOf: self.pokeAPI.loadPokemons(idFilter: searchBar.text!,
//                                                                                          totalLoaded: self.filteredpokemonsBasicInfo.count,
//                                                                                          lastId: self.filteredpokemonsBasicInfo[self.filteredpokemonsBasicInfo.count - 1]?.nationalNumber ?? 0))
//          } else {
//              print(self.filteredpokemonsBasicInfo)
//              var lastId = self.filteredpokemonsBasicInfo.count - 1 > 0 ? self.filteredpokemonsBasicInfo.count - 1 : 0
//              var lastPokeNumber = self.filteredpokemonsBasicInfo.isEmpty ? 1 : self.filteredpokemonsBasicInfo[lastId]?.nationalNumber ?? 0
//              self.filteredpokemonsBasicInfo.append(contentsOf: self.pokeAPI.loadPokemons(nameFilter: searchBar.text!,
//                                                                                          totalLoaded: self.filteredpokemonsBasicInfo.count,
//                                                                                          lastId: lastPokeNumber))
//          }
      }
      tableView.reloadData()
  }

}
