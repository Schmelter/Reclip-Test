//
//  ActivityIndicator.swift
//  ReclipFeaturedFeed
//

import UIKit

final class ActivityIndicator: UIView {

    private static let animationKey = "rotation"

    private let imageView: UIImageView = {
        let subview = UIImageView(image: UIImage(named: "RingLoader"))
        return subview
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addSubview(imageView)
        imageView.fillSuperview()
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if (newWindow != nil) && !(imageView.layer.animationKeys() ?? []).contains(Self.animationKey) {
            startRotating()
        }
    }

    private func startRotating() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 1
        rotation.repeatCount = .infinity
        imageView.layer.add(rotation, forKey: Self.animationKey)
    }
}
