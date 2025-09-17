//
//  TableView.swift
//  InterestingChallenges
//
//  Created by specktro on 16/09/25.
//

import UIKit

// Complete Table View Controller Implementation
final class TableView: UITableViewController {
    private var items: [ImageItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSampleData()
    }
    
    private func setupTableView() {
        // Register the cell class (no nib needed!)
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.identifier)
        
        // Configure table view for better performance
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        
        // Enable prefetching for smooth scrolling
        tableView.prefetchDataSource = self
        
        // Setup navigation
        title = "Image Loading Demo"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Clear Cache",
            style: .plain,
            target: self,
            action: #selector(clearCache)
        )
    }
    
    @objc private func clearCache() {
        AdvancedImageLoader.shared.clearMemoryCache()
        tableView.reloadData()
    }
    
    private func setupSampleData() {
        // Sample URLs - replace with real image URLs
        let sampleURLs = [
            "https://picsum.photos/300/200?random=1",
            "https://picsum.photos/300/300?random=2",
            "https://picsum.photos/300/250?random=3",
            "https://picsum.photos/300/180?random=4",
            "https://picsum.photos/300/220?random=5"
        ]
        
        items = sampleURLs.enumerated().compactMap { index, urlString in
            guard let url = URL(string: urlString) else { return nil }
            return ImageItem(id: "\(index)", title: "Image \(index + 1)", imageURL: url)
        }
        
        // Duplicate items to create a longer list for testing
        items = Array(repeating: items, count: 20).flatMap { $0 }
    }
    
    // Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as! ImageTableViewCell
        cell.configure(with: items[indexPath.row])
        return cell
    }
}

// Prefetching for Better Performance
extension TableView: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        // Preload images for upcoming cells
        for indexPath in indexPaths {
            let item = items[indexPath.row]
            AdvancedImageLoader.shared.loadImage(from: item.imageURL) { _ in
                // We don't need to do anything with the result
                // The image is now cached for when the cell appears
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        // Step 7B: Cancel prefetching if user scrolls away quickly
        // Note: Our current implementation doesn't track prefetch tasks
        // In a production app, you'd want to track and cancel these too
    }
}
