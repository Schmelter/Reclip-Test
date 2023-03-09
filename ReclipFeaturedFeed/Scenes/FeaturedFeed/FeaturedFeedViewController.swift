//
//  FeaturedFeedViewController.swift
//  ReclipFeaturedFeed
//

import UIKit

final class FeaturedFeedViewController: UIViewController {

    private let viewModel = FeaturedFeedViewModel()
    private lazy var progressBar = ProgressBar()
    private lazy var loadingViewController = LoadingViewController()

    private let label: UILabel = {
        let subview = UILabel()
        return subview
    }()

    override func loadView() {

        // Note: Using OutOfBoundsTouchView here allows lower half
        // of `progressBar` to receive touches.
        view = OutOfBoundsTouchView()

        view.backgroundColor = .white

        view.addSubview(label)
        label.font = .reclipBold(ofSize: 24)
        label.text = "Hello, featured feed!"

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setProgressBarHidden(_ hidden: Bool) {
        switch hidden {
        case false:
            view.addSubview(progressBar)
            progressBar.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                progressBar.progressBarBottomAnchor.constraint(equalTo: view.bottomAnchor),
                progressBar.heightAnchor.constraint(equalToConstant: 44)
            ])
        case true:
            progressBar.removeFromSuperview()
        }
    }

    private func setChild(_ child: UIViewController?) {
        children.first?.willMove(toParent: nil)
        children.first?.view.removeFromSuperview()
        children.first?.removeFromParent()

        if let child = child {
            addChild(child)
            view.addSubview(child.view)
            child.view.fillSuperview()
            child.didMove(toParent: self)
        }
    }
}
