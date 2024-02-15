//
//  FilterOptionTableViewCell.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 24/08/22.
//

import UIKit

class FilterOptionTableViewCell: UITableViewCell {

    let identifier: String = "FilterOptionCell"

    let types: [String] = ["normal",
                           "fire",
                           "water",
                           "grass",
                           "electric",
                           "ice",
                           "fighting",
                           "poison",
                           "ground",
                           "flying",
                           "psychic",
                           "bug",
                           "rock",
                           "ghost",
                           "dark",
                           "dragon",
                           "steel",
                           "fairy"]

    var selectedTypes: [String] = []

    internal lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 60)
        let collectionView = UICollectionView(frame: self.contentView.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FilterTypeCollectionViewCell.self,
                                forCellWithReuseIdentifier: FilterTypeCollectionViewCell().identifier)
        collectionView.allowsSelection = true
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    func setupData() {
        self.addSubviews()
        self.setupConstraints()
    }

    fileprivate func addSubviews() {
        self.contentView.addSubview(self.collectionView)
    }

    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])

    }

}

extension FilterOptionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let customCell = self.collectionView
            .dequeueReusableCell(withReuseIdentifier: FilterTypeCollectionViewCell().identifier,
                                 for: indexPath) as? FilterTypeCollectionViewCell
        else { fatalError("There should be a cell with \(identifier) identifier.") }
        customCell.type = self.types[indexPath.row]
        customCell.tapped = false
        customCell.setupData()
        return customCell
    }

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let customCell = self.collectionView
//            .dequeueReusableCell(withReuseIdentifier: FilterTypeCollectionViewCell().identifier,
//                                 for: indexPath) as? FilterTypeCollectionViewCell
//        else { fatalError("There should be a cell with \(identifier) identifier.") }
//        print(customCell.type)
//
//        collectionView.reloadData()
//    }
}

class FilterTypeCollectionViewCell: UICollectionViewCell {
    let identifier: String = "FilterTypeCell"

    var type: String?
    var tapped: Bool?

    internal lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.selectedType(_:)), for: .touchUpInside)
        return button
    }()

    func setupData() {
        self.contentView.addSubview(self.button)
        NSLayoutConstraint.activate([
            self.button.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.button.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.button.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.button.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),

            self.button.heightAnchor.constraint(equalTo: self.contentView.heightAnchor)
        ])
        self.button.setImage(UIImage(named: "type.\(type ?? "")"), for: .normal)
    }

    @objc func selectedType(_ sender: Any) {
        if (self.tapped ?? false) == true {
            self.button.setImage(UIImage(named: "type.\(type ?? "").selected"), for: .normal)
            self.tapped = false
        } else {
            self.button.setImage(UIImage(named: "type.\(type ?? "")"), for: .selected)
            self.tapped = true
        }
    }
}
