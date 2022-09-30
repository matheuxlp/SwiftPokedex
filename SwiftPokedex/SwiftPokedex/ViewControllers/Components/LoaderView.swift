//
//  LoaderViewController.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 26/09/22.
//

import UIKit

class LoaderView: UIView {

    private let spinner: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)

    init(_ isHidden: Bool = false) {
        super.init(frame: CGRect.zero)
        self.setupBackgroundView(isHidden)
        self.setupSpinner()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBackgroundView(_ isHidden: Bool) {
        self.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.25)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isHidden = isHidden
    }

    private func setupSpinner() {
        self.spinner.translatesAutoresizingMaskIntoConstraints = false
        self.spinner.startAnimating()
        self.spinner.color = UIColor.white
        self.addSubview(self.spinner)
        NSLayoutConstraint.activate([
            self.spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    func showLoader() {
        self.isHidden = false
        self.spinner.startAnimating()
    }

    func hideLoader() {
        self.isHidden = true
        self.spinner.stopAnimating()
    }

}
