//
//  SimpleTreeCell.swift
//  InterestingChallenges
//
//  Created by specktro on 08/09/25.
//

import UIKit

// MARK: - Simple Tree Cell
class SimpleTreeCell: UICollectionViewCell {
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let parentLabel = UILabel()
    private let expandButton = UIButton(type: .system)
    private let depthIndicator = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Container
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowRadius = 3
        containerView.layer.shadowOpacity = 0.1
        
        // Title label - big, bold, rounded
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.7
        
        // Parent label - subtitle/caption
        parentLabel.font = .systemFont(ofSize: 12, weight: .medium)
        parentLabel.textColor = .secondaryLabel
        parentLabel.numberOfLines = 1
        
        // Expand button
        expandButton.setTitle("▼", for: .normal)
        expandButton.setTitle("▶", for: .selected)
        expandButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        expandButton.tintColor = .systemBlue
        expandButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        expandButton.layer.cornerRadius = 12
        
        // Depth indicator
        depthIndicator.layer.cornerRadius = 2
        
        // Add subviews
        contentView.addSubview(containerView)
        containerView.addSubview(depthIndicator)
        containerView.addSubview(titleLabel)
        containerView.addSubview(parentLabel)
        containerView.addSubview(expandButton)
        
        [containerView, titleLabel, parentLabel, expandButton, depthIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            
            // Depth indicator
            depthIndicator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            depthIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            depthIndicator.widthAnchor.constraint(equalToConstant: 4),
            depthIndicator.heightAnchor.constraint(equalToConstant: 20),
            
            // Expand button
            expandButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            expandButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            expandButton.widthAnchor.constraint(equalToConstant: 24),
            expandButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Title label
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: depthIndicator.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: expandButton.leadingAnchor, constant: -8),
            
            // Parent label
            parentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            parentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            parentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            parentLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with node: SimpleNode) {
        titleLabel.text = node.value.title
        
        // Parent label - show only if has parent and hide if root
        if let parent = node.parent {
            parentLabel.text = "Parent: \(parent.value.title)"
            parentLabel.isHidden = false
        } else {
            parentLabel.isHidden = true
        }
        
        // Depth indicator color
        let depthColors: [UIColor] = [.systemRed, .systemOrange, .systemYellow, .systemGreen, .systemBlue, .systemPurple]
        depthIndicator.backgroundColor = depthColors[min(node.depth, depthColors.count - 1)]
        
        // Expand button
        expandButton.isHidden = node.children.isEmpty
        expandButton.isSelected = !node.isExpanded
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        parentLabel.text = nil
        parentLabel.isHidden = false
        expandButton.isHidden = true
    }
}

// MARK: - Simple Section Header
class SimpleSectionHeader: UICollectionReusableView {
    
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .systemGroupedBackground
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .left
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
