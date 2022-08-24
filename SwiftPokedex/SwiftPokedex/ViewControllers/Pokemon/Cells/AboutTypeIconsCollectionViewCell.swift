//
//  AboutTypeIconsCollectionViewCell.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 24/08/22.
//

import UIKit

class AboutTypeIconsCollectionViewCell: UICollectionViewCell {

    var type: String?

    @IBOutlet weak var typeBadgeImage: UIImageView!

    func setupData() {
        self.backgroundColor = UIColor(named: "type.\(type ?? "")")
        self.layer.cornerRadius = 4
        self.typeBadgeImage.image = UIImage(named: "badge.\(type ?? "")")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension UIImage {

    func resizeImageTo(size: CGSize) -> UIImage? {

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
