//
//  OutOfBoundsTouchView.swift
//  ReclipFeaturedFeed
//

import UIKit

/**
 Detects touches in subviews even when those subviews are outside of self's bounds.
 */
class OutOfBoundsTouchView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if subviews.contains(where: {
            !$0.isHidden && $0.isUserInteractionEnabled && $0.point(inside: convert(point, to: $0), with: event)
        }) {
            return true
        }
        return super.point(inside: point, with: event)
    }
}
