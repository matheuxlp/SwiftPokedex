//
//  String+Extensions.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 06/09/22.
//

import UIKit

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
