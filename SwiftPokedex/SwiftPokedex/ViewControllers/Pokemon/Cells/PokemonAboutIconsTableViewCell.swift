//
//  PokemonAboutIconsTableViewCell.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 24/08/22.
//

import UIKit

class PokemonAboutIconsTableViewCell: UITableViewCell {

    let identifier: String = "PokemonAboutIconsCell"

    var weaknesses: [String]?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    func setupData() {
        self.titleLabel.text = "Weaknesses"
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

extension PokemonAboutIconsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weaknesses?.count ?? 0
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("got here")
        let identifier = "AboutTypeIconsCell"
        guard let customCell = self.collectionView.dequeueReusableCell(
            withReuseIdentifier: identifier, for: indexPath) as? AboutTypeIconsCollectionViewCell
        else {
            fatalError("There should be a cell with \(identifier) identifier.")
        }
        customCell.type = weaknesses?[indexPath.row]
        customCell.setupData()

        return customCell
    }
}
