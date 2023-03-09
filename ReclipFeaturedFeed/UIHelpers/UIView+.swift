//
//  UIView+.swift
//  ReclipFeaturedFeed
//

import UIKit

extension UIView {

    func fillSuperview(insets: UIEdgeInsets = .zero) {
        guard let superview = superview else {
            assertionFailure()
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.left),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        ])
    }

    func fillSuperview(inset: CGFloat) {
        return fillSuperview(insets: .init(top: inset, left: inset, bottom: inset, right: inset))
    }

    func centerInSuperview() {
        guard let superview = superview else {
            assertionFailure()
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }
}

