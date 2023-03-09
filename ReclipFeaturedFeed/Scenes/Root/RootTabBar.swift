//
//  RootTabBar.swift
//  ReclipFeaturedFeed
//

import UIKit

protocol RootTabBarDelegate: AnyObject {
    func didTapFeatured()
    func didTapLibrary()
}

final class RootTabBar: UIView {

    weak var delegate: RootTabBarDelegate?

    private let featuredButton: TabBarButton = {
        let title = "Featured"
        let subview = TabBarButton(
            iconSet: .tabBarFeatured,
            title: title,
            textColor: .text,
            pressedTextColor: .subtle,
            selectedTextColor: .bright,
            selectedPressedTextColor: .neutral
        )
        subview.accessibilityLabel = title
        subview.translatesAutoresizingMaskIntoConstraints = false
        return subview
    }()
    private let captureButton: UIButton = {
        let subview = UIButton()
        subview.setImage(UIImage(named: "ReclipButton"), for: .normal)
        subview.accessibilityLabel = "Capture"
        subview.setContentHuggingPriority(.required, for: .horizontal)
        subview.setContentHuggingPriority(.required, for: .vertical)
        subview.translatesAutoresizingMaskIntoConstraints = false
        return subview
    }()
    private let libraryButton: TabBarButton = {
        let title = "Library"
        let subview = TabBarButton(
            iconSet: .tabBarLibrary,
            title: title,
            textColor: .dim,
            pressedTextColor: .neutral,
            selectedTextColor: .text,
            selectedPressedTextColor: .subtle
        )
        subview.accessibilityLabel = title
        subview.translatesAutoresizingMaskIntoConstraints = false
        return subview
    }()
    private let blurBackgroundView: UIView = {
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        return visualEffectView
    }()

    // MARK: Initializers

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    // MARK: Internal Methods

    func setFeaturedSelected() {
        featuredButton.isSelected = true
        libraryButton.isSelected = false
        blurBackgroundView.isHidden = true
        backgroundColor = .text
    }

    func setLibrarySelected() {
        featuredButton.isSelected = false
        libraryButton.isSelected = true
        blurBackgroundView.isHidden = false
        backgroundColor = .clear
    }

    // MARK: Private Methods

    @objc private func didTapFeatured() {
        delegate?.didTapFeatured()
    }

    @objc private func didTapLibrary() {
        delegate?.didTapLibrary()
    }

    private func commonInit() {

        addSubview(blurBackgroundView)

        // Featured button

        featuredButton.addTarget(self, action: #selector(didTapFeatured), for: .touchUpInside)
        addSubview(featuredButton)

        // Library button

        libraryButton.addTarget(self, action: #selector(didTapLibrary), for: .touchUpInside)
        addSubview(libraryButton)

        // Capture button

        addSubview(captureButton)

        // Constraints

        blurBackgroundView.fillSuperview()

        let captureButtonPadding: CGFloat = 6
        NSLayoutConstraint.activate([
            captureButton.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            captureButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            featuredButton.centerYAnchor.constraint(equalTo: captureButton.centerYAnchor),
            libraryButton.centerYAnchor.constraint(equalTo: captureButton.centerYAnchor),
            featuredButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            featuredButton.trailingAnchor.constraint(equalTo: captureButton.leadingAnchor, constant: -captureButtonPadding),
            libraryButton.leadingAnchor.constraint(equalTo: captureButton.trailingAnchor, constant: captureButtonPadding),
            libraryButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

private class TabBarButton: UIButton {

    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            updateAppearance()
        }
    }

    override var intrinsicContentSize: CGSize {
        // Add 2x label height to keep the image vertically centered within bounds.
        let size = Self.imageSize + 2.0 * Typography.mini.lineHeight
        return CGSize(width: size, height: size)
    }

    private static let imageSize: CGFloat = 32.0

    private let nameLabel: ReclipLabel = {
        let label = ReclipLabel(style: Typography.mini)
        label.isUserInteractionEnabled = false
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    private let iconSet: IconSet
    private let textColor: UIColor
    private let pressedTextColor: UIColor
    private let selectedTextColor: UIColor
    private let selectedPressedTextColor: UIColor

    // MARK: Initializers

    init(
        iconSet: IconSet,
        title: String,
        textColor: UIColor,
        pressedTextColor: UIColor,
        selectedTextColor: UIColor,
        selectedPressedTextColor: UIColor
    ) {
        self.iconSet = iconSet
        self.textColor = textColor
        self.pressedTextColor = pressedTextColor
        self.selectedTextColor = selectedTextColor
        self.selectedPressedTextColor = selectedPressedTextColor
        super.init(frame: .zero)

        nameLabel.text = title

        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: Self.imageSize / 2.0)
        ])

        updateAppearance()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    @available(*, unavailable)
    override init(frame: CGRect) {
        fatalError("Not implemented")
    }

    @available(*, unavailable)
    init() {
        fatalError("Not implemented")
    }

    // MARK: Private Methods

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        CGRect(
            origin: .init(
                x: (contentRect.width - Self.imageSize) / 2.0,
                y: (contentRect.height - Self.imageSize) / 2.0
            ),
            size: .init(
                width: Self.imageSize,
                height: Self.imageSize
            )
        )
    }

    private func updateAppearance() {
        // Seems like the image passed to `setImage(..., for:.highlighted)` is ignored
        // if the button is also selected, so always set the image manually.
        switch (isSelected, isHighlighted) {
        case (true, true):
            setImage(iconSet.selectedPressed, for: .normal)
            nameLabel.style = Typography.miniBold
            nameLabel.textColor = selectedPressedTextColor
        case (true, false):
            setImage(iconSet.selected, for: .normal)
            nameLabel.style = Typography.miniBold
            nameLabel.textColor = selectedTextColor
        case (false, true):
            setImage(iconSet.pressed, for: .normal)
            nameLabel.style = Typography.mini
            nameLabel.textColor = pressedTextColor
        default:
            setImage(iconSet.normal, for: .normal)
            nameLabel.style = Typography.mini
            nameLabel.textColor = textColor
        }
    }
}

/**
 An icon with more than one asset variation.

 At a minimum, the icon will have `normal` and `pressed` assets.
 If `hasSelectedState` is `true`, then the icon is also guaranteed to
 have `selected` and `selectedPressed` assets.
 */
private enum IconSet: String, CaseIterable {
    case tabBarFeatured = "TabBarFeaturedIcon"
    case tabBarLibrary = "TabBarLibraryIcon"

    private static let pressedSuffix = "Pressed"
    private static let selectedSuffix = "Selected"
    private static let selectedPressedSuffix = "SelectedPressed"

    var normal: UIImage? {
        UIImage(named: rawValue)
    }

    var pressed: UIImage? {
        UIImage(named: rawValue + Self.pressedSuffix)
    }

    var selected: UIImage? {
        UIImage(named: rawValue + Self.selectedSuffix)
    }

    var selectedPressed: UIImage? {
        UIImage(named: rawValue + Self.selectedPressedSuffix)
    }
}
