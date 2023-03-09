//
//  ReclipLabel.swift
//  ReclipFeaturedFeed
//

import UIKit

/**
 `UILabel` subclass that renders Reclip standard typography styles.
 */
class ReclipLabel: UILabel {

    var style: Typography.StyleDescriptor {
        didSet {
            // Reset the text to reattribute the string for the new style.
            let currentText = text
            text = currentText
        }
    }

    override var text: String? {
        get {
            super.attributedText?.string
        }
        set {
            if let newValue = newValue {
                super.attributedText = style.attributedString(
                    string: newValue,
                    alignment: textAlignment,
                    lineBreakMode: lineBreakMode
                )
            } else {
                super.attributedText = nil
            }
        }
    }

    init(style: Typography.StyleDescriptor) {
        self.style = style
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    init() {
        fatalError("Not implemented")
    }

    @available(*, unavailable)
    override init(frame: CGRect) {
        fatalError("Not implemented")
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    // Move text up to vertically center-align the first line.
    override func drawText(in rect: CGRect) {
        let lineOffset = (style.lineHeight - style.font.lineHeight) / 2.0
        var newRect = rect
        newRect.origin.y -= lineOffset
        super.drawText(in: newRect)
    }
}
