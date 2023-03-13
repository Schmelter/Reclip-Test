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
    
    init(
        id:String,
        share: ShareModel,
        createdBy: String,
        createdAt: Date?
    ) {
        self.id = id
        self.share = share
        self.createdBy = createdBy
        self.createdAt = createdAt
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
    
    init(
        id: String,
        reclipId: String,
        code: String,
        userId: String,
        username: String,
        videoTitle: String,
        videoFilename: String,
        videoUrl: String,
        url: String,
        createdAt: Date?,
        endedAt: Date?,
        disabled: Bool,
        videoProgress: Float
    ) {
        self.id = id
        self.reclipId = reclipId
        self.code = code
        self.userId = userId
        self.username = username
        self.videoTitle = videoTitle
        self.videoFilename = videoFilename
        self.videoUrl = videoUrl
        self.url = url
        self.createdAt = createdAt
        self.endedAt = endedAt
        self.disabled = disabled
        self.videoProgress = videoProgress
    }
}
