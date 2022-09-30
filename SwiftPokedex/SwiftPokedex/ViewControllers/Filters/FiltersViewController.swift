//
//  FiltersViewController.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 24/08/22.
//

import UIKit

class FiltersViewController: UIViewController {

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FilterOptionTableViewCell.self,
                           forCellReuseIdentifier: FilterOptionTableViewCell().identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.addSubviews()
        self.setupConstraints()
    }

    fileprivate func addSubviews() {
        self.view.addSubview(self.tableView)
    }

    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

extension FiltersViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String

        switch indexPath.section {
        case 0...3:
            identifier = FilterOptionTableViewCell().identifier
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
