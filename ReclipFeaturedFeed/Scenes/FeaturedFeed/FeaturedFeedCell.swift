//
//  FeaturedFeedCell.swift
//  ReclipFeaturedFeed
//

import UIKit
import AVFoundation
import AVKit

final class FeaturedFeedCell: UITableViewCell {
    
    private lazy var controller: AVPlayerViewController = {
        let player = AVPlayer(playerItem: nil)
        let controller = AVPlayerViewController()
        controller.player = player
        controller.videoGravity = AVLayerVideoGravity.resizeAspect
        controller.showsPlaybackControls = false
        return controller
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
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
        self.controller.player?.replaceCurrentItem(with: nil)
        self.titleLabel.text = nil
    }
}

// MARK: - Video Control
extension FeaturedFeedCell {
    func isPlaying() -> Bool {
        if let player = controller.player {
            return player.rate != 0 && player.error == nil
        }
        return false
    }
    
    func playPauseVideo() {
        if let player = controller.player {
            if (isPlaying()) {
                player.pause()
            } else {
                guard let duration = player.currentItem?.duration, let currentTime = player.currentItem?.currentTime() else {
                    return
                }
                if duration.seconds == 0 {
                    // No video?
                    return
                }
                
                // Reset the video if they're within 2 second of the end, play otherwise
                if duration.seconds - currentTime.seconds < 2 {
                    player.seek(to: CMTime.zero)
                }
                player.play()
            }
        }
    }
    
    func pauseVideo() {
        if let player = controller.player {
            player.pause()
        }
    }
}

// MARK: - Configure
extension FeaturedFeedCell {
    func bindToViewModel(viewModel: FeaturedFeedCellViewModel) {
        guard let videoURL = URL(string: viewModel.videoUrl) else { return }
        
        if contentView.subviews.count == 0 {
            // Needs to be configured
            if let playerView = controller.view {
                playerView.translatesAutoresizingMaskIntoConstraints = false
                playerView.backgroundColor = UIColor.black
                contentView.addSubview(playerView)
                playerView.fillSuperview()
            }
        }
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        
        self.titleLabel.text = viewModel.videoTitle
        controller.player?.replaceCurrentItem(with: AVPlayerItem(url: videoURL))
        controller.player?.seek(to: viewModel.videoTimeProgress.value.0, toleranceBefore: CMTime(value: 0, timescale: timeScale), toleranceAfter: CMTime(value: 0, timescale: timeScale))
        
        let time = CMTime(seconds: 0.1, preferredTimescale: timeScale)
        controller.player?.addPeriodicTimeObserver(forInterval: time, queue: .main, using: { [unowned self] videoTime in
            if let player = self.controller.player {
                let duration = CMTimeGetSeconds(player.currentItem!.duration)
                
                // Make sure duration makes sense, and we don't divide by zero
                guard duration != 0.0 && !duration.isNaN else {
                    viewModel.videoTimeProgress.value = (CMTime.zero, 0.0)
                    return
                }
                
                let videoProgress = Float(CMTimeGetSeconds(videoTime) / duration)
                viewModel.videoTimeProgress.value = (videoTime, videoProgress)
            }
        })
    }
}
