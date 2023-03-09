//
//  LibraryViewController.swift
//  ReclipFeaturedFeed
//

import UIKit

final class LibraryViewController: UIViewController {
    let label: UILabel = {
        let subview = UILabel()
        return subview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(label)
        label.font = .reclipBold(ofSize: 24)
        label.text = "Hello, library!"

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
