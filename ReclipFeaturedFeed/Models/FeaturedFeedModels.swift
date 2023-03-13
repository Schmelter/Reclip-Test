//
//  FeaturedFeedModels.swift
//  ReclipFeaturedFeed
//

import Foundation
import AVKit

protocol FeaturedFeedModel: Codable {
    var id: String {get set}
    var share: ShareModelImpl {get set}
    var createdBy: String {get set}
    var createdAt: Date? {get set}
}

protocol ShareModel: Codable {
    var id: String {get set}
    var reclipId: String {get set}
    var code: String {get set}
    var userId: String {get set}
    var username: String {get set}
    var videoTitle: String {get set}
    var videoFilename: String {get set}
    var videoUrl: String {get set}
    var url: String {get set}
    var createdAt: Date? {get set}
    var endedAt: Date? {get set}
    var disabled: Bool {get set}
    
    var videoProgress: Optional<Float> {get set}
}

struct FeaturedFeedModelImpl: FeaturedFeedModel {
    var id: String
    var share: ShareModelImpl
    var createdBy: String
    var createdAt: Date?
    
    init(featuredFeedModel: FeaturedFeedModel, videoProgress: Float) {
        self.id = featuredFeedModel.id
        self.share = ShareModelImpl(shareModel: featuredFeedModel.share, videoProgress: videoProgress)
        self.createdBy = featuredFeedModel.createdBy
        self.createdAt = featuredFeedModel.createdAt
    }
}

struct ShareModelImpl: ShareModel {
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
