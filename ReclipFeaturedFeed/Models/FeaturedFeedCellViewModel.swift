//
//  FeaturedFeedCellViewModel.swift
//  ReclipFeaturedFeed
//

import Foundation
import AVKit

final class FeaturedFeedCellViewModel {
    
    var videoTitle: String
    var videoUrl: String
    var videoProgress: Dynamic<(Float)>
    var state: Dynamic<VideoState>
    
    init(videoTitle: String, videoUrl: String, videoProgress: Float) {
        self.videoTitle = videoTitle
        self.videoUrl = videoUrl
        self.videoProgress = Dynamic(videoProgress)
        
        // All videos start out paused
        self.state = Dynamic<VideoState>(.paused)
    }
}
