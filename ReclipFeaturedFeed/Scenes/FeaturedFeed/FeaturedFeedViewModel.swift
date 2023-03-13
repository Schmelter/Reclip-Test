//
//  FeaturedFeedViewModel.swift
//  ReclipFeaturedFeed
//

import Foundation
import AVKit

final class FeaturedFeedViewModel {
    var state: Dynamic<ViewState>
    
    private var featuredFeeds: [FeaturedFeedModel] = []
    
    init() {
        self.state = Dynamic<ViewState>(.idle)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveData), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(loadData), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
}

// MARK: - DataSource
extension FeaturedFeedViewModel {
    var numberOfItems: Int {
        featuredFeeds.count
    }

    func getCellViewModel(for indexPath: IndexPath) -> FeaturedFeedCellViewModel {
        let featuredFeed = featuredFeeds[indexPath.row]
        // Returned a paired down tuple with just the info the View is interested in
        return FeaturedFeedCellViewModel(
            videoTitle: featuredFeed.share.videoTitle,
            videoUrl: featuredFeed.share.videoUrl,
            videoProgress: featuredFeed.share.videoProgress ?? 0)
    }
    
    func updateVideoProgress(for indexPath: IndexPath, videoProgress: Float) {
        var featuredFeed = featuredFeeds[indexPath.row]
        featuredFeed.share.videoProgress = Optional<Float>(videoProgress)
        featuredFeeds[indexPath.row] = featuredFeed
    }
}

// MARK: - Service
extension FeaturedFeedViewModel {
    @objc func loadData() {
        self.state.value = .loading
        FeaturedFeedAPI.getAllFeaturedFeeds { result in
            switch result {
            case let .success(featuredFeeds):
                self.featuredFeeds = featuredFeeds
                self.state.value = .success
            case let .failure(error):
                self.featuredFeeds = []
                self.state.value = .error(error)
            }
        }
    }
    
    @objc func saveData() {
        FeaturedFeedAPI.saveToUserDefaults(featuredFeedModels: featuredFeeds)
    }
}
