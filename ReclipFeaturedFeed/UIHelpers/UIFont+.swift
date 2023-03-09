//
//  UIFont+.swift
//  ReclipFeaturedFeed
//

import UIKit

extension UIFont {

    static func reclipRegular(ofSize size: CGFloat) -> UIFont {
        .reclip(.regular, size: size)
    }

    static func reclipRegularItalic(ofSize size: CGFloat) -> UIFont {
        .reclip(.regularItalic, size: size)
    }

    static func reclipMedium(ofSize size: CGFloat) -> UIFont {
        .reclip(.medium, size: size)
    }

    static func reclipSemibold(ofSize size: CGFloat) -> UIFont {
        .reclip(.semibold, size: size)
    }

    static func reclipBold(ofSize size: CGFloat) -> UIFont {
        .reclip(.bold, size: size)
    }

    static func reclipBoldItalic(ofSize size: CGFloat) -> UIFont {
        .reclip(.boldItalic, size: size)
    }

    static func reclipExtrabold(ofSize size: CGFloat) -> UIFont {
        .reclip(.extrabold, size: size)
    }

    static func reclipBlack(ofSize size: CGFloat) -> UIFont {
        .reclip(.black, size: size)
    }

    private static func reclip(_ variant: FontVariant, size: CGFloat) -> UIFont {
        return UIFont(name: variant.rawValue, size: size)
        ?? backupFont(variant: variant, size: size)
    }

    private static func backupFont(variant: FontVariant, size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: backupWeight(variant: variant))
    }

    private static func backupWeight(variant: FontVariant) -> UIFont.Weight {
        switch variant {
        case .regular, .regularItalic:
            return .regular
        case .medium:
            return .medium
        case .semibold:
            return .semibold
        case .bold, .boldItalic:
            return .bold
        case .extrabold:
            return .heavy
        case .black:
            return .black
        }
    }
}

private enum FontVariant: String, CaseIterable {
    /** Weight: 400 */
    case regular = "ProximaNova-Regular"
    /** Weight: 400 */
    case regularItalic = "ProximaNova-RegularIt"
    /** Weight: 500 */
    case medium = "ProximaNova-Medium"
    /** Weight: 600 */
    case semibold = "ProximaNova-Semibold"
    /** Weight: 700 */
    case bold = "ProximaNova-Bold"
    /** Weight: 700 */
    case boldItalic = "ProximaNova-BoldIt"
    /** Weight: 800 */
    case extrabold = "ProximaNova-Extrabld"
    /** Weight: 900 */
    case black = "ProximaNova-Black"
}
