//
//  FeaturedFeedCellViewModel.swift
//  ReclipFeaturedFeed
//

import Foundation
import AVKit

final class FeaturedFeedCellViewModel {
    
    var videoTitle: String
    var videoUrl: String
    var videoTimeProgress: Dynamic<(CMTime, Float)>
    var state: Dynamic<VideoState>
    
    init(videoTitle: String, videoUrl: String, videoProgress: Float, videoTime: CMTime) {
        self.videoTitle = videoTitle
        self.videoUrl = videoUrl
        self.videoTimeProgress = Dynamic((videoTime, videoProgress))
        
        // All videos start out paused
        self.state = Dynamic<VideoState>(.paused)
    }
}
