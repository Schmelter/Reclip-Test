//
//  FeaturedFeedCellViewModelTests.swift
//  ReclipFeaturedFeed
//

import XCTest
@testable import ReclipFeaturedFeed

class FeaturedFeedCellViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFeedCellStoresPropertiesAndStateIsPaused() {
        let feedCell: FeaturedFeedCellViewModel = FeaturedFeedCellViewModel(
            videoId: "videoId",
            videoTitle: "videoTitle",
            videoUrl: "videoUrl",
            videoProgress: 1.0
            )
        XCTAssertEqual(feedCell.videoId, "videoId", "videoId does not match")
        XCTAssertEqual(feedCell.videoTitle, "videoTitle", "videoTitle does not match")
        XCTAssertEqual(feedCell.videoUrl, "videoUrl", "videoUrl does not match")
        XCTAssertEqual(feedCell.videoProgress.value, 1.0, "videoProgress does not match")
        XCTAssertEqual(feedCell.state.value, .paused, "state is not paused")
    }

    func testVideoProgressDynamic() throws {
        // Test that video progress dynamically calls back when it changes
        let feedCell: FeaturedFeedCellViewModel = FeaturedFeedCellViewModel(
            videoId: "videoId",
            videoTitle: "videoTitle",
            videoUrl: "videoUrl",
            videoProgress: 1.0
        )
        
        var fired: Bool = false
        feedCell.videoProgress.bind { videoProgress in
            fired = true
        }
        feedCell.videoProgress.value = 1.0
        
        XCTAssertTrue(fired, "Video Progress Dynamic not fired")
    }
    
    func testVideoStateDynamic() throws {
        // Test that video state dynamically calls back when it changes
        let feedCell: FeaturedFeedCellViewModel = FeaturedFeedCellViewModel(
            videoId: "videoId",
            videoTitle: "videoTitle",
            videoUrl: "videoUrl",
            videoProgress: 1.0
        )
        
        var fired: Bool = false
        feedCell.state.bind { videoState in
            fired = true
        }
        feedCell.state.value = .playing
        
        XCTAssertTrue(fired, "Video Progress Dynamic not fired")
    }

}

