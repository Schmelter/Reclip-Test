//
//  FeaturedFeedModels.swift
//  ReclipFeaturedFeed
//

import Foundation

struct FeaturedFeedModel: Codable {
    var id: String
    var share: ShareModel
    var createdBy: String
    var createdAt: Date?
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
}
