//
//  LoadingViewCard.swift
//  ReclipFeaturedFeed
//

import UIKit

final class LoadingViewCard: UIView {

    override var intrinsicContentSize: CGSize {
        CGSize(width: 278, height: 156)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowRadius = 24
        layer.shadowOpacity = 0.15

        let secondaryDropShadowView = UIView()
        addSubview(secondaryDropShadowView)
        secondaryDropShadowView.fillSuperview()

        secondaryDropShadowView.layer.shadowColor = UIColor.black.cgColor
        secondaryDropShadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
        secondaryDropShadowView.layer.shadowRadius = 8
        secondaryDropShadowView.layer.shadowOpacity = 0.1

        let clippingContainer = UIView()
        secondaryDropShadowView.addSubview(clippingContainer)
        clippingContainer.fillSuperview()
        clippingContainer.backgroundColor = .bright
        clippingContainer.layer.cornerRadius = 24
        clippingContainer.clipsToBounds = true

        let borderGradient = GradientBorderView(colors: [
            .init(color: .fromHex(red: 0x36, green: 0x36, blue: 0x36).withAlphaComponent(0), location: 0),
            .init(color: .fromHex(red: 0x47, green: 0x47, blue: 0x47).withAlphaComponent(0.3), location: 1)
        ], borderWidth: 2)
        borderGradient.layer.cornerRadius = 24
        clippingContainer.addSubview(borderGradient)
        borderGradient.fillSuperview()

        let label = ReclipLabel(style: Typography.transcript)
        label.text = "Loading Content"

        let stackView = UIStackView(arrangedSubviews: [label, ActivityIndicator()])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

private final class GradientBorderView: UIView {

    private let borderMask: CAShapeLayer = {
        let sublayer = CAShapeLayer()
        sublayer.fillColor = UIColor.white.cgColor
        return sublayer
    }()
    private let borderWidth: CGFloat

    init(colors: [VerticalGradientView.ColorAndLocation], borderWidth: CGFloat) {
        self.borderWidth = borderWidth
        super.init(frame: .zero)
        setUp(colors: colors)
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

    private func setUp(colors: [VerticalGradientView.ColorAndLocation]) {
        let gradientView = VerticalGradientView(colors: colors)
        addSubview(gradientView)
        gradientView.fillSuperview()

        gradientView.layer.mask = borderMask
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        let outerPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
        let innerPath = UIBezierPath(roundedRect: bounds.insetBy(dx: borderWidth, dy: borderWidth), cornerRadius: layer.cornerRadius - borderWidth).reversing()
        outerPath.append(innerPath)
        borderMask.path = outerPath.cgPath
    }
}

