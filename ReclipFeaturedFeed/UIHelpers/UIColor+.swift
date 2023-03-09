//
//  Color.swift
//  ReclipFeaturedFeed
//

import UIKit

extension UIColor {

    // MARK: Shades and Tints

    static let dark = UIColor.fromHex(red: 0x0f, green: 0x0f, blue: 0x0f)
    static let text = UIColor.fromHex(red: 0x26, green: 0x26, blue: 0x26)
    static let subtle = UIColor.fromHex(red: 0x73, green: 0x73, blue: 0x73)
    static let neutral = UIColor.fromHex(red: 0xb2, green: 0xb2, blue: 0xb2)
    static let dim = UIColor.fromHex(red: 0xe5, green: 0xe5, blue: 0xe5)
    static let light = UIColor.fromHex(red: 0xf0, green: 0xf0, blue: 0xf0)
    static let bright = UIColor.fromHex(red: 0xfa, green: 0xfa, blue: 0xfa)

    // MARK: Color Palette

    static let primaryOrange = UIColor.fromHex(red: 0xff, green: 0xb8, blue: 0x00)
    static let paleOrange = UIColor.fromHex(red: 0xff, green: 0xd0, blue: 0x56)
    static let paleYellow = UIColor.fromHex(red: 0xfd, green: 0xff, blue: 0x96)
    static let skyBlue = UIColor.fromHex(red: 0x9e, green: 0xdc, blue: 0xff)
    static let periwinkle = UIColor.fromHex(red: 0x72, green: 0x99, blue: 0xff)
    static let deepBlue = UIColor.fromHex(red: 0x50, green: 0x33, blue: 0xff)
    static let deepIndigo = UIColor.fromHex(red: 0x45, green: 0x0a, blue: 0xa5)
    static let secondaryFuschia = UIColor.fromHex(red: 0xe9, green: 0x3a, blue: 0x74)
}

extension UIColor {
    static func fromHex(red: UInt8 = 0x00, green: UInt8 = 0x00, blue: UInt8 = 0x00) -> UIColor {
        return UIColor(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: 1.0
        )
    }
}
