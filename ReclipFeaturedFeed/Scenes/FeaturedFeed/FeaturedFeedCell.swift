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
        controller.view.frame = CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
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
    
    private lazy var playPauseButton: UIButton = {
       let playPauseButton = UIButton()
        playPauseButton.setImage(nil, for: .normal)
        playPauseButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        return playPauseButton
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .white
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.controller.player?.replaceCurrentItem(with: nil)
        self.titleLabel.text = nil
    }
    
    // MARK: - IBActions
    @IBAction func playVideo(_ sender: UIButton) {
        if let player = controller.player {
            if (player.rate != 0 && player.error == nil) {
                player.pause()
            } else {
                player.play()
            }
        }
    }
}

// MARK: - Configure Layout
private extension FeaturedFeedCell {
    func configureLayout() {
        backgroundColor = .white
        
        contentView.addSubview(controller.view)
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            controller.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            controller.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            controller.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        contentView.addSubview(playPauseButton)
        playPauseButton.fillSuperview()
    }
}

// MARK: - Configure
extension FeaturedFeedCell {
    func configure(info: (videoTitle: String, videoUrl: String)) {
        guard let videoURL = URL(string: info.videoUrl) else { return }
        
        self.titleLabel.text = info.videoTitle
        controller.player?.replaceCurrentItem(with: AVPlayerItem(url: videoURL))
    }
}
