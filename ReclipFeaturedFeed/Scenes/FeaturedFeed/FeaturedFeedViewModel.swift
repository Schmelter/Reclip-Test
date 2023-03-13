//
//  FeaturedFeedViewModel.swift
//  ReclipFeaturedFeed
//

import Foundation
import AVKit

final class FeaturedFeedViewModel {
    
    private let featuredFeedApi: FeaturedFeedAPI
    var state: Dynamic<ViewState>
    private(set) var cellViewModels: Array<FeaturedFeedCellViewModel> = []
    
    init(featuredFeedApi: FeaturedFeedAPI) {
        self.featuredFeedApi = featuredFeedApi
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
        return cellViewModels.count
    }

    func getCellViewModel(for indexPath: IndexPath) -> FeaturedFeedCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func updateVideoProgress(for indexPath: IndexPath, videoProgress: Float) {
        let cellViewModel = cellViewModels[indexPath.row]
        cellViewModel.videoProgress.value = videoProgress
        cellViewModels[indexPath.row] = cellViewModel
    }
}

// MARK: - Service
extension FeaturedFeedViewModel {
    private func buildCellViewModel(featuredFeed: FeaturedFeedModel) -> FeaturedFeedCellViewModel {
        return FeaturedFeedCellViewModel(
            videoId: featuredFeed.id,
            videoTitle: featuredFeed.share.videoTitle,
            videoUrl: featuredFeed.share.videoUrl,
            videoProgress: featuredFeed.share.videoProgress ?? 0)
    }
    
    @objc func loadData() {
        self.state.value = .loading
        featuredFeedApi.getAllFeaturedFeeds { result in
            switch result {
            case let .success(featuredFeeds):
                self.cellViewModels = []
                for featuredFeed in featuredFeeds {
                    self.cellViewModels.append(self.buildCellViewModel(featuredFeed: featuredFeed))
                }
                self.state.value = .success
            case let .failure(error):
                self.cellViewModels = []
                self.state.value = .error(error)
            }
        }
    }
    
    @objc func saveData() {
        let idToVideoProgressDict: Dictionary<String, Float> = cellViewModels.reduce(into: [String: Float]()) { partialResult, cellViewModel in
            partialResult[cellViewModel.videoId] = cellViewModel.videoProgress.value
        }
        
        featuredFeedApi.saveToUserDefaults(idToVideoProgressDict: idToVideoProgressDict)
    }
}
