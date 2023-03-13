//
//  FeaturedFeedCell.swift
//  ReclipFeaturedFeed
//

import UIKit
import AVFoundation
import AVKit

final class FeaturedFeedCell: UITableViewCell {
    
    let playerView: VideoPlayerView = VideoPlayerView()
    
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
    }
    
    func pause() {
        self.playerView.pause()
    }
}

// MARK: - Configure
extension FeaturedFeedCell {
    func bindToViewModel(viewModel: FeaturedFeedCellViewModel) {
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
