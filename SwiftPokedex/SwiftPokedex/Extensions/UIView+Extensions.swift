//
//  UIView+Extensions.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 24/08/22.
//

import UIKit

extension UIView {
    func comingFromRight(containerView: UIView) {
        let offset = CGPoint(x: containerView.frame.maxX, y: 0)
        let posX: CGFloat = 0, posY: CGFloat = 0
        self.transform = CGAffineTransform(translationX: offset.x + posX, y: offset.y + posY)
        self.isHidden = false
        UIView.animate(
            withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.transform = .identity
            })
    }

    func comingFromLeft(containerView: UIView) {
        let offset = CGPoint(x: -containerView.frame.maxX, y: 0)
        let posX: CGFloat = 0, posY: CGFloat = 0
        self.transform = CGAffineTransform(translationX: offset.x + posX, y: offset.y + posY)
        self.isHidden = false
        UIView.animate(
            withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.transform = .identity
            })
    }
}
