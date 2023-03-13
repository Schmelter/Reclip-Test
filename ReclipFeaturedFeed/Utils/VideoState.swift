//
//  VideoState.swift
//  ReclipFeaturedFeed
//

import Foundation

enum VideoState: Equatable {
    static func == (lhs: VideoState, rhs: VideoState) -> Bool {
        switch (lhs, rhs) {
        case (.playing, .playing):
            return true
        case (.paused, .paused):
            return true
        default:
            return false
        }
    }
    
    case playing
    case paused
}
