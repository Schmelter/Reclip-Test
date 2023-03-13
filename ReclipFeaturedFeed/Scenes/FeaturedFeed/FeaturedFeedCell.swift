//
//  FeaturedFeedCell.swift
//  ReclipFeaturedFeed
//

import UIKit
import AVFoundation
import AVKit

final class FeaturedFeedCell: UITableViewCell {
    
    let playerView: VideoPlayerView = VideoPlayerView()
    weak var viewModel: FeaturedFeedCellViewModel? = nil
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.playerView.url = nil
    }
}

// MARK: - Video Control
extension FeaturedFeedCell {
    func isPaused() -> Bool {
        return self.playerView.isPaused
    }
    
    func togglePlayback() {
        self.playerView.togglePlayback()
        if (self.playerView.isPaused) {
            self.viewModel?.state.value = .paused
        } else {
            self.viewModel?.state.value = .playing
        }
    }
    
    func pause() {
        self.playerView.pause()
        self.viewModel?.state.value = .paused
    }
}

// MARK: - Configure
extension FeaturedFeedCell {
    func bindToViewModel(viewModel: FeaturedFeedCellViewModel) {
        self.viewModel = viewModel
        guard let videoURL = URL(string: viewModel.videoUrl) else { return }
        
        if contentView.subviews.count == 0 {
            // Needs to be configured
            playerView.translatesAutoresizingMaskIntoConstraints = false
            playerView.backgroundColor = UIColor.black
            contentView.addSubview(playerView)
            playerView.fillSuperview()
        }
        
        playerView.url = videoURL
        playerView.setPlaybackProgress(viewModel.videoProgress.value)
        playerView.playbackProgress.bindAndFire { videoProgress in
            viewModel.videoProgress.value = videoProgress
        }
    }
}
