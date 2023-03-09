//
//  LoadingViewController.swift
//  ReclipFeaturedFeed
//

import UIKit

final class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let brightGradientView = VerticalGradientView(colors: [
            .init(color: .fromHex(red: 0xff, green: 0xcf, blue: 0xa3), location: 0.0),
            .init(color: .fromHex(red: 0xff, green: 0x6b, blue: 0x3e), location: 0.35),
            .init(color: .fromHex(red: 0x99, green: 0x3c, blue: 0xff), location: 1.0),
        ])
        view.addSubview(brightGradientView)
        brightGradientView.fillSuperview()

        let lightOverlayView = VerticalGradientView(colors: [
            .init(color: .bright.withAlphaComponent(0.8), location: 0.0),
            .init(color: .bright.withAlphaComponent(0.5), location: 1.0)
        ])
        view.addSubview(lightOverlayView)
        lightOverlayView.fillSuperview()

        let darkOverlayView = VerticalGradientView(colors: [
            .init(color: .dark.withAlphaComponent(0.35), location: 0.0),
            .init(color: .dark.withAlphaComponent(0.15), location: 1.0)
        ])
        view.addSubview(darkOverlayView)
        darkOverlayView.fillSuperview()

        let card = LoadingViewCard()
        view.addSubview(card)
        card.centerInSuperview()
    }
}
