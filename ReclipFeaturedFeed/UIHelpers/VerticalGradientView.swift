//
//  VerticalGradientView.swift
//  ReclipFeaturedFeed
//

import UIKit

final class VerticalGradientView: UIView {

    struct ColorAndLocation {
        let color: UIColor
        let location: NSNumber
    }

    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    init(colors: [ColorAndLocation]) {
        super.init(frame: .zero)
        (layer as? CAGradientLayer)?.colors = colors.map(\.color.cgColor)
        (layer as? CAGradientLayer)?.locations = colors.map(\.location)
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
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}
