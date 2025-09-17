//
//  ImageTableViewCell.swift
//  InterestingChallenges
//
//  Created by specktro on 16/09/25.
//

import UIKit

// Table View Cell with Proper Request Management
final class ImageTableViewCell: UITableViewCell {
    // Create UI elements programmatically
    private let customImageView = UIImageView()
    private let titleLabel = UILabel()
    private let containerView = UIView()
    
    // Track the current task to enable cancellation
    private var currentImageTask: URLSessionDataTask?
    
    // Track what URL this cell is supposed to show
    private var currentImageURL: URL?
    
    // Cell identifier for registration
    static let identifier = "ImageTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Container view for better layout control
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.1
        
        // Configure image view
        customImageView.contentMode = .scaleAspectFill
        customImageView.clipsToBounds = true
        customImageView.layer.cornerRadius = 8
        customImageView.backgroundColor = .systemGray6
        
        // Configure title label
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .left
        
        // Add subviews
        contentView.addSubview(containerView)
        containerView.addSubview(customImageView)
        containerView.addSubview(titleLabel)
        
        // Disable autoresizing masks
        containerView.translatesAutoresizingMaskIntoConstraints = false
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container view constraints
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Image view constraints
            customImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            customImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            customImageView.widthAnchor.constraint(equalToConstant: 80),
            customImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Title label constraints
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(greaterThanOrEqualTo: containerView.bottomAnchor, constant: -12),
            
            // Ensure minimum height
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 104)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Cancel any ongoing request
        currentImageTask?.cancel()
        currentImageTask = nil
        currentImageURL = nil
        
        // Clear the image to prevent flickering
        customImageView.image = nil
        titleLabel.text = nil
    }
    
    func configure(with item: ImageItem) {
        titleLabel.text = item.title
        
        // Store the URL we're about to load
        currentImageURL = item.imageURL
        
        // Set placeholder image immediately
        customImageView.image = UIImage(systemName: "photo")
        
        // Start loading the image
        currentImageTask = AdvancedImageLoader.shared.loadImage(from: item.imageURL) { [weak self] result in
            // Verify this cell still wants this image
            guard let self = self,
                  self.currentImageURL == item.imageURL else {
                return // Cell was reused for different content
            }
            
            switch result {
            case .success(let image):
                // Animate the image appearance
                UIView.transition(with: self.customImageView,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve) {
                    self.customImageView.image = image
                }
                
            case .failure(_):
                // Show error state
                self.customImageView.image = UIImage(systemName: "exclamationmark.triangle")
            }
            
            // Clear the task reference
            self.currentImageTask = nil
        }
    }
}
