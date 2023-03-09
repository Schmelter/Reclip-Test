//
//  VideoPlayerView.swift
//  ReclipFeaturedFeed
//

import Combine
import AVKit
import UIKit

final class VideoPlayerView: UIView {

    var url: URL? {
        get {
            ((player.currentItem?.asset) as? AVURLAsset)?.url
        }
        set {
            setItem(forURL: newValue)
        }
    }

    @Published private(set) var playbackProgress: Float = 0

    var isPaused: Bool {
        player.timeControlStatus == .paused
    }

    private let player = AVPlayer()
    private var timeObserverToken: Any?
    private var cancellables = Set<AnyCancellable>()
    private var pendingPlaybackProgress: Float?
    private var currentItemStatusSubscriber: AnyCancellable?

    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func play() {
        player.play()
    }

    func pause() {
        player.pause()
    }

    func togglePlayback() {
        if player.timeControlStatus == .paused {
            player.play()
        } else {
            player.pause()
        }
    }

    func setPlaybackProgress(_ newProgress: Float) {
        switch player.currentItem?.status {
        case .readyToPlay:
            seek(toProgress: newProgress)
        default:
            pendingPlaybackProgress = newProgress
        }
    }

    // MARK: Private Methods

    private func seek(toProgress progress: Float) {
        guard let duration = player.currentItem?.duration else {
            assertionFailure()
            return
        }

        pendingPlaybackProgress = nil
        let newTime = duration.seconds * TimeInterval(progress)
        player.seek(to: CMTime(seconds: newTime, preferredTimescale: 1000000))
    }

    private func commonInit() {
        guard let playerLayer = layer as? AVPlayerLayer else {
            fatalError("Unexpected layer type.")
        }

        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        addPeriodicTimeObserver()
    }

    private func setItem(forURL url: URL?) {
        if let url = url {
            let item = AVPlayerItem(url: url)
            currentItemStatusSubscriber = item.publisher(for: \.status)
                .sink { [weak self] status in
                    if status == .readyToPlay, let progress = self?.pendingPlaybackProgress {
                        self?.seek(toProgress: progress)
                    }
                }
            player.replaceCurrentItem(with: item)
        } else {
            currentItemStatusSubscriber = nil
            player.replaceCurrentItem(with: nil)
        }
    }

    private func addPeriodicTimeObserver() {
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.1, preferredTimescale: timeScale)

        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
            self?.playbackTimeDidChange(to: time.seconds)
        }
    }

    private func playbackTimeDidChange(to newTime: TimeInterval) {
        guard let duration = player.currentItem?.duration else {
            return
        }
        guard player.currentItem?.status == .readyToPlay else {
            return
        }
        guard duration.seconds > 0 else {
            playbackProgress = 0
            return
        }

        playbackProgress = Float(newTime/duration.seconds)
    }
}
