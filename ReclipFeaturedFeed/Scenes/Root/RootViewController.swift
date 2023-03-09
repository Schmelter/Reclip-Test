//
//  RootViewController.swift
//  ReclipFeaturedFeed
//

import UIKit

final class RootViewController: UIViewController {

    private lazy var contentView = OutOfBoundsTouchView()
    private lazy var featuredFeedViewController = FeaturedFeedViewController()
    private lazy var libraryViewController = LibraryViewController()
    private lazy var tabBar = RootTabBar()

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.delegate = self

        view.addSubview(tabBar)
        view.addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -72),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        setFeaturedSelected()
    }

    private func setFeaturedSelected() {
        setContentViewController(featuredFeedViewController)
        tabBar.setFeaturedSelected()
    }

    private func setLibrarySelected() {
        setContentViewController(libraryViewController)
        tabBar.setLibrarySelected()
    }

    private func setContentViewController(_ child: UIViewController) {
        children.first?.willMove(toParent: nil)
        children.first?.view?.removeFromSuperview()
        children.first?.removeFromParent()

        addChild(child)
        contentView.addSubview(child.view)
        child.view.fillSuperview()
        child.didMove(toParent: self)
    }
}

extension RootViewController: RootTabBarDelegate {
    func didTapFeatured() {
        setFeaturedSelected()
    }

    func didTapLibrary() {
        setLibrarySelected()
    }
}
