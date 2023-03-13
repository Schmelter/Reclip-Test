//
//  FeaturedFeedViewModelTests.swift
//  ReclipFeaturedFeedTests
//

import XCTest
@testable import ReclipFeaturedFeed

class FeaturedFeedViewModelTests: XCTestCase {
    
    var shareModel: ShareModel?
    var featuredFeedModel: FeaturedFeedModel?
    
    override func setUpWithError() throws {
        shareModel = ShareModel(
            id: "id",
            reclipId: "reclipId",
            code: "code",
            userId: "userId",
            username: "username",
            videoTitle: "videoTitle",
            videoFilename: "videoFilename",
            videoUrl: "videoUrl",
            url: "url",
            createdAt: nil,
            endedAt: nil,
            disabled: false,
            videoProgress: 0.5
        )
        featuredFeedModel = FeaturedFeedModel(
            id: "id",
            share: shareModel!,
            createdBy: "createdBy",
            createdAt: nil
        )
    }

    override func tearDownWithError() throws {
        
    }

    func testSuccessfulCallToApiNoData() throws {
        let api = FeaturedFeedAPIMock()
        api.getAllResult = .success([])
        
        let viewModel = FeaturedFeedViewModel(featuredFeedApi: api)
        
        XCTAssertEqual(viewModel.state.value, .idle)
        
        var didLoadState = false
        var didSuccessState = false
        var didErrorState = false
        viewModel.state.bind { state in
            switch (state) {
            case .loading:
                didLoadState = true
            case .idle:
                break
            case .success:
                didSuccessState = true
            case .error:
                didErrorState = true
            }
        }
        viewModel.loadData()
        
        XCTAssertTrue(didLoadState)
        XCTAssertTrue(didSuccessState)
        XCTAssertFalse(didErrorState)
        XCTAssertEqual(0, viewModel.cellViewModels.count)
    }
    
    func testSuccessfulCallToApiWithData() throws {
        let api = FeaturedFeedAPIMock()
        api.getAllResult = .success([
            featuredFeedModel!,
            featuredFeedModel!,
            featuredFeedModel!,
            featuredFeedModel!,
            featuredFeedModel!])
        
        let viewModel = FeaturedFeedViewModel(featuredFeedApi: api)
        
        XCTAssertEqual(viewModel.state.value, .idle)
        
        var didLoadState = false
        var didSuccessState = false
        var didErrorState = false
        viewModel.state.bind { state in
            switch (state) {
            case .loading:
                didLoadState = true
            case .idle:
                break
            case .success:
                didSuccessState = true
            case .error:
                didErrorState = true
            }
        }
        viewModel.loadData()
        
        XCTAssertTrue(didLoadState)
        XCTAssertTrue(didSuccessState)
        XCTAssertFalse(didErrorState)
        XCTAssertEqual(5, viewModel.cellViewModels.count)
    }
    
    func testErroredCallToApi() throws {
        
    }

}
