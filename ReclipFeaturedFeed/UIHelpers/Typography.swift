//
//  Typography.swift
//  ReclipFeaturedFeed
//

import UIKit

enum Typography {
    struct StyleDescriptor {
        struct Outline {
            let foregroundColor: UIColor
            let strokeColor: UIColor
            let strokeWidth: CGFloat
        }

        let font: UIFont
        let lineHeight: CGFloat

        /**
         Specifies the number of points by which to adjust kern-pair characters.

         - Warning: Setting this to `0` disables automatic kerning, meaning that values defined in the font's
           kern table will not be applied. Leave `nil` to preserve automatic kerning.
         */
        let kernAdjustment: CGFloat?
        let uppercased: Bool
        let outline: Outline?

        /**
         Returns an attributed string for the style.

         Note that the resulting text has the correct line height, but is incorrectly bottom-aligned in each line. We typically want to vertically center-align the text in
         each line. Unfortunately, `NSAttributedString.Key.baselineOffset` seems to have a bug that makes it unreliable to use for vertically
         center-aligning the text out of the box, so it is recommended to use ReclipLabel/-TextField to render the style instead of working with the attributed string directly.
         */
        func attributedString(
            string: String,
            alignment: NSTextAlignment,
            lineBreakMode: NSLineBreakMode
        ) -> NSAttributedString {

            return
                NSAttributedString(
                    string: uppercased ? string.uppercased() : string,
                    attributes: attributes(alignment: alignment, lineBreakMode: lineBreakMode)
                )
        }

        func attributes(
            alignment: NSTextAlignment,
            lineBreakMode: NSLineBreakMode? = nil
        ) -> [NSAttributedString.Key: Any] {

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = lineHeight
            paragraphStyle.maximumLineHeight = lineHeight
            paragraphStyle.alignment = alignment
            if let lineBreakMode = lineBreakMode {
                paragraphStyle.lineBreakMode = lineBreakMode
            }

            var attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .paragraphStyle: paragraphStyle
            ]

            if let kern = kernAdjustment {
                attributes[.kern] = kern
            }

            if let outline = outline {
                attributes[.foregroundColor] = outline.foregroundColor
                attributes[.strokeColor] = outline.strokeColor
                attributes[.strokeWidth] = -(outline.strokeWidth / font.pointSize) * 100.0
            }

            return attributes
        }
    }

    static let transcript = StyleDescriptor(
        font: .reclipExtrabold(ofSize: 22),
        lineHeight: 27.5,
        kernAdjustment: nil,
        uppercased: false,
        outline: nil
    )
    static let strong = StyleDescriptor(
        font: .reclipBold(ofSize: 16),
        lineHeight: 20,
        kernAdjustment: nil,
        uppercased: false,
        outline: nil
    )
    static let minor = StyleDescriptor(
        font: .reclipRegular(ofSize: 14),
        lineHeight: 17.5,
        kernAdjustment: 0.2,
        uppercased: false,
        outline: nil
    )
    static let mini = StyleDescriptor(
        font: .reclipMedium(ofSize: 10.0),
        lineHeight: 14.0,
        kernAdjustment: 0.3,
        uppercased: false,
        outline: nil
    )
    static let miniBold = StyleDescriptor(
        font: .reclipBold(ofSize: 10.0),
        lineHeight: mini.lineHeight,
        kernAdjustment: mini.kernAdjustment,
        uppercased: mini.uppercased,
        outline: mini.outline
    )
}
