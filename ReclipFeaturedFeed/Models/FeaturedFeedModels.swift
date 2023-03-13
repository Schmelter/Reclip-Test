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
    
    var videoTime: CMTime = CMTime.zero
    var videoProgress: Float = 0.0
    
    private enum CodingKeys: String, CodingKey {
        case id, reclipId, code, userId, username, videoTitle, videoFilename, videoUrl,
        url, createdAt, endedAt, disabled
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        reclipId = try container.decode(String.self, forKey: .reclipId)
        code = try container.decode(String.self, forKey: .code)
        userId = try container.decode(String.self, forKey: .userId)
        username = try container.decode(String.self, forKey: .username)
        videoTitle = try container.decode(String.self, forKey: .videoTitle)
        videoFilename = try container.decode(String.self, forKey: .videoFilename)
        videoUrl = try container.decode(String.self, forKey: .videoUrl)
        url = try container.decode(String.self, forKey: .url)
        createdAt = try? container.decode(Date.self, forKey: .createdAt)
        endedAt = try? container.decode(Date.self, forKey: .endedAt)
        disabled = try container.decode(Bool.self, forKey: .disabled)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(reclipId, forKey: .reclipId)
        try container.encode(code, forKey: .code)
        try container.encode(userId, forKey: .userId)
        try container.encode(username, forKey: .username)
        try container.encode(videoTitle, forKey: .videoTitle)
        try container.encode(videoFilename, forKey: .videoFilename)
        try container.encode(videoUrl, forKey: .videoUrl)
        try container.encode(url, forKey: .url)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(endedAt, forKey: .endedAt)
        try container.encode(disabled, forKey: .disabled)
    }
}
