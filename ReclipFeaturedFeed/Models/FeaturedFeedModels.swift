//
//  FeaturedFeedModels.swift
//  ReclipFeaturedFeed
//

import Foundation
import AVKit

struct FeaturedFeedModel: Codable {
    var id: String
    var share: ShareModel
    var createdBy: String
    var createdAt: Date?
    
    init(featuredFeedModel: FeaturedFeedModel, videoProgress: Float) {
        self.id = featuredFeedModel.id
        self.share = ShareModel(shareModel: featuredFeedModel.share, videoProgress: videoProgress)
        self.createdBy = featuredFeedModel.createdBy
        self.createdAt = featuredFeedModel.createdAt
    }
}

struct ShareModel: Codable {
    var id: String
    var reclipId: String
    var code: String
    var userId: String
    var username: String
    var videoTitle: String
    var videoFilename: String
    var videoUrl: String
    var url: String
    var createdAt: Date?
    var endedAt: Date?
    var disabled: Bool
    
    var videoProgress: Optional<Float> = 0.0
    
    init(shareModel: ShareModel, videoProgress: Float) {
        self.id = shareModel.id
        self.reclipId = shareModel.reclipId
        self.code = shareModel.code
        self.userId = shareModel.userId
        self.username = shareModel.username
        self.videoTitle = shareModel.videoTitle
        self.videoFilename = shareModel.videoFilename
        self.videoUrl = shareModel.videoUrl
        self.url = shareModel.url
        self.createdAt = shareModel.createdAt
        self.endedAt = shareModel.endedAt
        self.disabled = shareModel.disabled
        
        self.videoProgress = videoProgress
    }
}
