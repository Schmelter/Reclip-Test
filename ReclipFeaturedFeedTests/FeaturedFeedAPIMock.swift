//
//  FeaturedFeedAPIMock.swift
//  ReclipFeaturedFeed
//

import Foundation
@testable import ReclipFeaturedFeed

class FeaturedFeedAPIMock : FeaturedFeedAPI {
    
    var savedUserDefaults: [String: Float]? = nil
    var getAllResult: Result<[FeaturedFeedModel], Error>? = nil
    
    init() {
        super.init(endpoint: URL(string: "http://www.google.com")!)
    }
    
    override func getAllFeaturedFeeds(completion: @escaping (Result<[FeaturedFeedModel], Error>) -> Void) {
        completion(getAllResult!)
    }
    
    override func saveToUserDefaults(idToVideoProgressDict: [String: Float]) {
        self.savedUserDefaults = idToVideoProgressDict
    }
    
}
