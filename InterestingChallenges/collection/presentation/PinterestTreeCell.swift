//
//  PinterestTreeCell.swift
//  InterestingChallenges
//
//  Created by specktro on 08/09/25.
//

import UIKit

// MARK: - Pinterest Style Tree Cell
class PinterestTreeCell: UICollectionViewCell {
    // UI Components
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let overlayView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let categoryBadge = UILabel()
    private let saveCountLabel = UILabel()
    private let depthIndicator = UIView()
    private let expandButton = UIButton(type: .system)
    
    // Gradient layers
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Container styling
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.1
        containerView.clipsToBounds = false
        
        // Image view
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .systemGray5
        
        // Overlay for text readability
        overlayView.layer.cornerRadius = 12
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.7).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        overlayView.layer.addSublayer(gradientLayer)
        
        // Title label
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .left
        titleLabel.shadowColor = UIColor.black.withAlphaComponent(0.5)
        titleLabel.shadowOffset = CGSize(width: 0, height: 1)
        
        // Description label
        descriptionLabel.font = .systemFont(ofSize: 12, weight: .medium)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .left
        descriptionLabel.shadowColor = UIColor.black.withAlphaComponent(0.5)
        descriptionLabel.shadowOffset = CGSize(width: 0, height: 1)
        
        // Category badge
        categoryBadge.font = .systemFont(ofSize: 10, weight: .bold)
        categoryBadge.textColor = .white
        categoryBadge.backgroundColor = UIColor.systemRed.withAlphaComponent(0.9)
        categoryBadge.layer.cornerRadius = 8
        categoryBadge.clipsToBounds = true
        categoryBadge.textAlignment = .center
        
        // Save count label
        saveCountLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        saveCountLabel.textColor = .white
        saveCountLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        saveCountLabel.layer.cornerRadius = 10
        saveCountLabel.clipsToBounds = true
        saveCountLabel.textAlignment = .center
        
        // Depth indicator
        depthIndicator.layer.cornerRadius = 3
        
        // Expand button
        expandButton.setTitle("◯", for: .normal)
        expandButton.setTitle("◉", for: .selected)
        expandButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        expandButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.9)
        expandButton.layer.cornerRadius = 12
        expandButton.tintColor = .white
        
        // Add subviews
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(overlayView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(categoryBadge)
        containerView.addSubview(saveCountLabel)
        containerView.addSubview(depthIndicator)
        containerView.addSubview(expandButton)
        
        // Disable autoresizing masks
        [containerView, imageView, overlayView, titleLabel, descriptionLabel,
         categoryBadge, saveCountLabel, depthIndicator, expandButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            // Depth indicator
            depthIndicator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            depthIndicator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            depthIndicator.widthAnchor.constraint(equalToConstant: 6),
            depthIndicator.heightAnchor.constraint(equalToConstant: 30),
            
            // Image view
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: depthIndicator.trailingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            // Overlay view
            overlayView.topAnchor.constraint(equalTo: imageView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            
            // Category badge
            categoryBadge.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            categoryBadge.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 8),
            categoryBadge.heightAnchor.constraint(equalToConstant: 16),
            categoryBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 40),
            
            // Save count label
            saveCountLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            saveCountLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            saveCountLabel.heightAnchor.constraint(equalToConstant: 20),
            saveCountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 30),
            
            // Expand button
            expandButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8),
            expandButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            expandButton.widthAnchor.constraint(equalToConstant: 24),
            expandButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Title label
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -4),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -12),
            
            // Description label
            descriptionLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -12),
            descriptionLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: expandButton.leadingAnchor, constant: -8),
            
            // Container bottom constraint
            containerView.bottomAnchor.constraint(greaterThanOrEqualTo: imageView.bottomAnchor, constant: 8)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = overlayView.bounds
    }
    
    func configure(with node: PinNode) {
        let content = node.value
        
        // Configure labels
        titleLabel.text = content.title
        descriptionLabel.text = content.description
        categoryBadge.text = content.category
        
        // Format save count
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if content.saveCount >= 1000 {
            saveCountLabel.text = "\(content.saveCount / 1000)K"
        } else {
            saveCountLabel.text = "\(content.saveCount)"
        }
        
        // Configure depth indicator
        let depthColors: [UIColor] = [
            .systemRed, .systemOrange, .systemYellow,
            .systemGreen, .systemBlue, .systemPurple, .systemPink
        ]
        depthIndicator.backgroundColor = depthColors[min(node.depth, depthColors.count - 1)]
        
        // Configure expand button
        expandButton.isHidden = node.children.isEmpty
        expandButton.isSelected = node.isExpanded
        expandButton.alpha = node.children.isEmpty ? 0 : 1
        
        // Set placeholder image with color based on category
        setPlaceholderImage(for: content.category)
        
        // Add subtle entrance animation
        animateIn()
    }
    
    private func setPlaceholderImage(for category: String) {
        // Create colored placeholder based on category
        let colors: [String: UIColor] = [
            "Food": .systemOrange,
            "Home": .systemBlue,
            "Fashion": .systemPink,
            "Travel": .systemGreen,
            "DIY": .systemPurple,
            "Home Decor": .systemBlue,
            "Fashion & Style": .systemPink
        ]
        
        let color = colors[category] ?? .systemGray
        imageView.backgroundColor = color.withAlphaComponent(0.3)
        
        // Add simple pattern or icon
        DispatchQueue.main.async {
            self.addPatternToImageView(color: color)
        }
    }
    
    private func addPatternToImageView(color: UIColor) {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100))
        let patternImage = renderer.image { context in
            color.withAlphaComponent(0.5).setFill()
            context.fill(CGRect(x: 0, y: 0, width: 100, height: 100))
            
            // Add simple geometric pattern
            UIColor.white.withAlphaComponent(0.2).setFill()
            for i in stride(from: 0, to: 100, by: 20) {
                for j in stride(from: 0, to: 100, by: 20) {
                    if (i + j) % 40 == 0 {
                        context.fill(CGRect(x: i, y: j, width: 10, height: 10))
                    }
                }
            }
        }
        
        imageView.image = patternImage
    }
    
    private func animateIn() {
        contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        contentView.alpha = 0
        
        UIView.animate(
            withDuration: 0.6,
            delay: TimeInterval.random(in: 0...0.3),
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.5,
            options: [.allowUserInteraction]
        ) {
            self.contentView.transform = .identity
            self.contentView.alpha = 1
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        categoryBadge.text = nil
        saveCountLabel.text = nil
        expandButton.isHidden = true
        contentView.transform = .identity
        contentView.alpha = 1
    }
}

// MARK: - Pinterest Section Header
class PinterestSectionHeader: UICollectionReusableView {
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let separatorView = UIView()
    private let backgroundView = UIView()
    private let iconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Background
        backgroundView.backgroundColor = .systemBackground
        backgroundView.layer.cornerRadius = 12
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        backgroundView.layer.shadowRadius = 3
        backgroundView.layer.shadowOpacity = 0.1
        
        // Icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .systemRed
        iconImageView.backgroundColor = .systemRed.withAlphaComponent(0.1)
        iconImageView.layer.cornerRadius = 15
        iconImageView.clipsToBounds = true
        
        // Title
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        
        // Subtitle
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 1
        
        // Separator
        separatorView.backgroundColor = .systemRed.withAlphaComponent(0.3)
        separatorView.layer.cornerRadius = 1
        
        // Add subviews
        addSubview(backgroundView)
        backgroundView.addSubview(iconImageView)
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(subtitleLabel)
        backgroundView.addSubview(separatorView)
        
        [backgroundView, iconImageView, titleLabel, subtitleLabel, separatorView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Background view
            backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            // Icon
            iconImageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            // Title
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: backgroundView.trailingAnchor, constant: -16),
            
            // Subtitle
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -8),
            
            // Separator
            separatorView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    func configure(with title: String) {
        titleLabel.text = title
        
        // Set subtitle and icon based on section
        if title.contains("Home") {
            subtitleLabel.text = "Explore your personalized feed"
            iconImageView.image = UIImage(systemName: "house.fill")
        } else if title.contains("Level") {
            let levelNumber = title.replacingOccurrences(of: "Level ", with: "")
            subtitleLabel.text = "Tree depth: \(levelNumber)"
            iconImageView.image = UIImage(systemName: "arrow.down.right")
        } else {
            subtitleLabel.text = "Tap items to expand or view details"
            iconImageView.image = UIImage(systemName: "grid")
        }
        
        // Add entrance animation
        animateIn()
    }
    
    private func animateIn() {
        backgroundView.transform = CGAffineTransform(translationX: -50, y: 0)
        backgroundView.alpha = 0
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.1,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.3,
            options: [.allowUserInteraction]
        ) {
            self.backgroundView.transform = .identity
            self.backgroundView.alpha = 1
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        iconImageView.image = nil
        backgroundView.transform = .identity
        backgroundView.alpha = 1
    }
}
