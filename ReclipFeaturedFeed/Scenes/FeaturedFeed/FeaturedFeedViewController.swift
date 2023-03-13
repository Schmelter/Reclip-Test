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
        tableView.backgroundColor = .black
        return tableView
    }()
    
    required init(viewModel: FeaturedFeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bindToViewModel()
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
}


// MARK: UI Setup
private extension FeaturedFeedViewController {
    func configureLayout() {
        // Note: Using OutOfBoundsTouchView here allows lower half
        // of `progressBar` to receive touches.
        view = OutOfBoundsTouchView()

        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        
        addChild(loadingViewController)
        loadingViewController.didMove(toParent: self)
    }
}

// MARK: Loading View
private extension FeaturedFeedViewController {
    private func setLoadingViewHidden(_ hidden: Bool) {
        switch hidden {
        case false:
            view.addSubview(loadingViewController.view)
            loadingViewController.view.alpha = 0.0
            loadingViewController.view.fillSuperview()
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {
                self.loadingViewController.view.alpha = 1.0
            })
        case true:
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {
                self.loadingViewController.view.alpha = 0.0
            }, completion: { (finished: Bool) in
                self.loadingViewController.view.removeFromSuperview()
            })
        }
    }
}

// MARK: UITableViewDataSource & UITableViewDelegate
extension FeaturedFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: FeaturedFeedCell.self, indexPath: indexPath)
        let cellViewModel = viewModel.getCellViewModel(for: indexPath)
        cellViewModel.videoProgress.bind { [unowned self] videoProgress in
            self.progressBar.setProgress(videoProgress)
            self.viewModel.updateVideoProgress(for: indexPath, videoProgress: videoProgress)
        }
        cell.bindToViewModel(viewModel:cellViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // All videos are the same height, based on the height of the table view
        return tableView.bounds.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FeaturedFeedCell
        if (cell.isPaused()) {
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
        cell.togglePlayback()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let ffCell = cell as! FeaturedFeedCell
        ffCell.pause()
    }
}

// MARK: RequestDelegate
extension FeaturedFeedViewController {
    func bindToViewModel() {
        self.viewModel.state.bindAndFire { [unowned self] state in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch state {
                case .idle:
                    break
                case .loading:
                    self.setLoadingViewHidden(false)
                    self.setProgressBarHidden(true)
                case .success:
                    self.setLoadingViewHidden(true)
                    self.tableView.setContentOffset(.zero, animated: true)
                    self.tableView.reloadData()
                    self.setProgressBarHidden(false)
                case .error(let error):
                    self.setProgressBarHidden(true)
                    self.setLoadingViewHidden(true)
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                }
            }
        }
    }
}

