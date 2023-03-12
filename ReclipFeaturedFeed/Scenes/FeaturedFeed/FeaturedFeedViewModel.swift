//
//  FeaturedFeedViewModel.swift
//  ReclipFeaturedFeed
//

import Foundation
import AVKit

final class FeaturedFeedViewModel {
    weak var delegate: RequestDelegate?
    private var state: ViewState {
        didSet {
            self.delegate?.didUpdate(with: state)
        }
    }
    
    private var featuredFeeds: [FeaturedFeedModel] = []
    
    init() {
        self.state = .idle
    }
}

// MARK: - DataSource
extension FeaturedFeedViewModel {
    var numberOfItems: Int {
        featuredFeeds.count
    }

    func getInfo(for indexPath: IndexPath) -> (videoTitle: String, videoUrl: String, videoProgress: CMTime) {
        let featuredFeed = featuredFeeds[indexPath.row]
        // Returned a paired down tuple with just the info the View is interested in
        return (videoTitle: featuredFeed.share.videoTitle, videoUrl: featuredFeed.share.videoUrl, featuredFeed.share.videoProgress)
    }
}

// MARK: - Service
extension FeaturedFeedViewModel {
    func loadData() {
        self.state = .loading
        FeaturedFeedAPI.getAllFeaturedFeeds { result in
            switch result {
            case let .success(featuredFeeds):
                self.featuredFeeds = featuredFeeds
                self.state = .success
            case let .failure(error):
                self.featuredFeeds = []
                self.state = .error(error)
            }
        }
    }
}
