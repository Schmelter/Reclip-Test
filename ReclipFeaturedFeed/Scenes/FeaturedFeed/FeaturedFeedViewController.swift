//
//  FeaturedFeedViewController.swift
//  ReclipFeaturedFeed
//

import UIKit

final class FeaturedFeedViewController: UIViewController {

    private let viewModel: FeaturedFeedViewModel
    private lazy var progressBar = ProgressBar()
    private lazy var loadingViewController = LoadingViewController()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.registerCell(cellClass: FeaturedFeedCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        return tableView
    }()
    
    required init(viewModel: FeaturedFeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
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


// MARK: UI Setup
private extension FeaturedFeedViewController {
    func configureLayout() {
        // Note: Using OutOfBoundsTouchView here allows lower half
        // of `progressBar` to receive touches.
        view = OutOfBoundsTouchView()

        view.backgroundColor = .white
        
        view.addSubview(loadingViewController.view)
        loadingViewController.view.fillSuperview()

        view.addSubview(tableView)
        tableView.fillSuperview()
    }
}

// MARK: UITableViewDataSource & UITableViewDelegate
extension FeaturedFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: FeaturedFeedCell.self, indexPath: indexPath)
        cell.configure(info: viewModel.getInfo(for: indexPath))
        return cell
    }
}

// MARK: RequestDelegate
extension FeaturedFeedViewController: RequestDelegate {
    func didUpdate(with state: ViewState) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch state {
            case .idle:
                break
            case .loading:
                self.setProgressBarHidden(false)
            case .success:
                self.tableView.setContentOffset(.zero, animated: true)
                self.tableView.reloadData()
                self.setProgressBarHidden(true)
            case .error(let error):
                self.setProgressBarHidden(true)
                DispatchQueue.main.async { [weak self]  in
                    guard let self = self else { return }
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                }
            }
        }
    }
}

