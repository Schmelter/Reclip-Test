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
        let api = FeaturedFeedAPIMock()
        api.getAllResult = .failure("TEST ERROR")
        
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
        XCTAssertFalse(didSuccessState)
        XCTAssertTrue(didErrorState)
        XCTAssertEqual(0, viewModel.cellViewModels.count)
    }
    
    func testSuccessfulCallToApiCheckCells() throws {
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
        
        XCTAssertEqual(viewModel.numberOfItems, 5)
        
        for i in 0..<5 {
            let indexPath = IndexPath(item: i, section: 0)
            let feedCellViewModel = viewModel.getCellViewModel(for: indexPath)
            XCTAssertNotNil(feedCellViewModel)
            XCTAssertEqual(feedCellViewModel.videoId, featuredFeedModel!.id)
            XCTAssertEqual(feedCellViewModel.videoTitle, featuredFeedModel!.share.videoTitle)
            XCTAssertEqual(feedCellViewModel.videoUrl, featuredFeedModel!.share.videoUrl)
            XCTAssertEqual(feedCellViewModel.videoProgress.value, featuredFeedModel!.share.videoProgress)
            XCTAssertEqual(feedCellViewModel.state.value, .paused)
            
            var didProgress: Bool = false
            feedCellViewModel.videoProgress.bind { videoProgress in
                didProgress = true
            }
            viewModel.updateVideoProgress(for: indexPath, videoProgress: 1.0)
            XCTAssertTrue(didProgress)
            
            var didState: Bool = false
            feedCellViewModel.state.bind { state in
                didState = true
            }
            feedCellViewModel.state.value = .playing
            XCTAssertTrue(didState)
        }
    }
    
    func testSaveData() throws {
        let api = FeaturedFeedAPIMock()
        api.getAllResult = .success([
            featuredFeedModel!,
            featuredFeedModel!,
            featuredFeedModel!,
            featuredFeedModel!,
            featuredFeedModel!])
        
        let viewModel = FeaturedFeedViewModel(featuredFeedApi: api)
        viewModel.loadData()
        viewModel.saveData()
        
        XCTAssertNotNil(api.savedUserDefaults)
        
        if let savedUserDefaults = api.savedUserDefaults {
            for (videoId, videoProgress) in savedUserDefaults {
                XCTAssertEqual(videoId, "id")
                XCTAssertEqual(videoProgress, 0.5)
            }
        }
    }

}
