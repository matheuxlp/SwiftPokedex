//
//  FiltersViewController.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 24/08/22.
//

import UIKit

class FiltersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var instructionsLabel: UILabel!

    @IBOutlet weak var resetButtonOutlet: UIButton!
    @IBOutlet weak var appleButtonOutlet: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
    }
}

extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String

        switch indexPath.section {
        case 0...3:
            identifier = "FilterOptionTableViewCell"
            guard let customCell = self.tableView.dequeueReusableCell(withIdentifier: identifier,
                                                                      for: indexPath) as? FilterOptionTableViewCell
            else { fatalError("There should be a cell with \(identifier) identifier.") }

            customCell.setupData()

            return customCell
        case 4:
            identifier = ""
        case 5:
            identifier = ""
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Types"
        case 1:
            return "Weaknesses"
        case 2:
            return "Heights"
        case 3:
            return "Weights"
        case 4:
            return "Number Range"
        default:
            return ""
        }
    }
}
