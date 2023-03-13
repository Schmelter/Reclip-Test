//
//  FeaturedFeedViewModelTests.swift
//  ReclipFeaturedFeedTests
//

import XCTest
@testable import ReclipFeaturedFeed

class FeaturedFeedViewModelTests: XCTestCase {

    let cellViewModel = FeaturedFeedCellViewModel(
        videoId: "videoId",
        videoTitle: "videoTitle",
        videoUrl: "videoUrl",
        videoProgress: 0.5
    )
    let shareModel = ShareModel()
    
    let shareModel = ShareModel(
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

    let featuredFeedModel = FeaturedFeedModel(
        id: "id",
        share: shareModel,
        createdBy: "createdBy",
        createdAt: nil
    )
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
            cellViewModel,
            cellViewModel,
            cellViewModel,
            cellViewModel,
            cellViewModel])
        
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
