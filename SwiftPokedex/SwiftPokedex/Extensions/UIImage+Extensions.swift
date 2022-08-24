//
//  UIImage+Extensions.swift
//  SwiftPokedex
//
//  Created by Matheus Polonia on 24/08/22.
//

import UIKit

extension UIImage {
    func maskWithGradientColor(_ firstColor: UIColor, _ secondColor: UIColor? = nil) -> UIImage? {

        let maskImage = self.cgImage
        let width = self.size.width
        let height = self.size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let bitmapContext = CGContext(data: nil,
                                      width: Int(width),
                                      height: Int(height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: 0,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo.rawValue)

        let locations: [CGFloat] = [0.0, 1.0]
        let bottom = firstColor.cgColor
        let top = secondColor?.cgColor ?? UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor
        let colors = [top, bottom] as CFArray
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
        let startPoint = CGPoint(x: width/2, y: 0)
        let endPoint = CGPoint(x: width/2, y: height)

        bitmapContext!.clip(to: bounds, mask: maskImage!)
        bitmapContext!.drawLinearGradient(gradient!, start: startPoint, end: endPoint,
                                          options: CGGradientDrawingOptions(rawValue: UInt32(0)))

        if let cImage = bitmapContext!.makeImage() {
            let coloredImage = UIImage(cgImage: cImage)
            return coloredImage
        } else {
            return nil
        }
    }

    func maskWithGradientColor2(_ firstColor: UIColor, _ secondColor: UIColor? = nil) -> UIImage? {

        let maskImage = self.cgImage
        let width = self.size.width
        let height = self.size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let bitmapContext = CGContext(data: nil,
                                      width: Int(width),
                                      height: Int(height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: 0,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo.rawValue)

        let locations: [CGFloat] = [0.0, 1.0]
        let bottom = firstColor.cgColor
        let top = secondColor?.cgColor ?? UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor
        let colors = [top, bottom] as CFArray
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
        let startPoint = CGPoint(x: width, y: height/2)
        let endPoint = CGPoint(x: 0, y: height/2)

        bitmapContext!.clip(to: bounds, mask: maskImage!)
        bitmapContext!.drawLinearGradient(gradient!, start: startPoint, end: endPoint,
                                          options: CGGradientDrawingOptions(rawValue: UInt32(0)))

        if let cImage = bitmapContext!.makeImage() {
            let coloredImage = UIImage(cgImage: cImage)
            return coloredImage
        } else {
            return nil
        }
    }
}
