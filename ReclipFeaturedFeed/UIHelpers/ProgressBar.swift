//
//  ProgressBar.swift
//  ReclipFeaturedFeed
//

import UIKit

final class ProgressBar: UIView {

    var onPan: ((Float) -> Void)?

    var progressBarBottomAnchor: NSLayoutYAxisAnchor {
        progressBar.bottomAnchor
    }

    private let playheadContainer = UIView()
    private let progressBar: UIProgressView = {
        let subview = UIProgressView()
        subview.trackTintColor = .bright
        subview.progressTintColor = .primaryOrange
        subview.progress = 0.5
        return subview
    }()
    private var playheadCenterX: NSLayoutConstraint?
    private var isPanning = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func setProgress(_ progress: Float) {
        guard !isPanning else {
            return
        }
        progressBar.progress = progress
        playheadCenterX?.constant = playheadContainer.bounds.width * CGFloat(progress)
    }

    private func commonInit() {

        addSubview(progressBar)

        // Keeps entire playhead onscreen
        addSubview(playheadContainer)

        let playheadView = UIImageView(image: UIImage(named: "Playhead"))
        playheadContainer.addSubview(playheadView)

        let dragView = UIView()
        addSubview(dragView)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        dragView.addGestureRecognizer(pan)

        progressBar.translatesAutoresizingMaskIntoConstraints = false
        playheadContainer.translatesAutoresizingMaskIntoConstraints = false
        playheadView.translatesAutoresizingMaskIntoConstraints = false
        dragView.translatesAutoresizingMaskIntoConstraints = false

        let playheadCenterX = playheadView.centerXAnchor.constraint(equalTo: playheadContainer.leadingAnchor)
        let dragViewCenter = dragView.centerXAnchor.constraint(equalTo: playheadView.centerXAnchor)
        dragViewCenter.priority = .init(rawValue: 999)
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressBar.centerYAnchor.constraint(equalTo: centerYAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 2),
            playheadContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            playheadContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            playheadContainer.topAnchor.constraint(equalTo: topAnchor),
            playheadContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            playheadView.centerYAnchor.constraint(equalTo: playheadContainer.centerYAnchor, constant: 4),
            playheadCenterX,
            dragView.widthAnchor.constraint(equalToConstant: 44),
            dragView.topAnchor.constraint(equalTo: topAnchor),
            dragView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dragViewCenter,
            dragView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            dragView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
        ])
        self.playheadCenterX = playheadCenterX
    }

    @objc private func didPan(_ gesture: UIPanGestureRecognizer) {

        switch gesture.state {
        case .cancelled, .ended, .failed, .possible:
            isPanning = false
        default:
            isPanning = true
        }

        let translation = gesture.translation(in: gesture.view)
        gesture.setTranslation(.zero, in: gesture.view)

        let currentX = playheadCenterX?.constant ?? 0
        let clampedX = min(max(0, currentX + translation.x), playheadContainer.bounds.width)
        self.playheadCenterX?.constant = clampedX

        let relativePoint = convert(CGPoint(x: clampedX, y: 0), from: playheadContainer)
        let relativeProgress = relativePoint.x / progressBar.frame.width
        progressBar.progress = Float(relativeProgress)

        onPan?(Float(clampedX / playheadContainer.bounds.width))
    }
}
