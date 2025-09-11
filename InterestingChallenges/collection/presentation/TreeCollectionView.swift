//
//  TreeCollectionViewController.swift
//  InterestingChallenges
//
//  Created by specktro on 09/09/25.
//

import UIKit

// MARK: - Main Collection View Controller
class TreeCollectionView: UICollectionViewController, PinterestLayoutDelegate {
    private var treeRoot: PinNode?
    private var displayData: [(node: PinNode, section: Int, isVisible: Bool)] = []
    private var sectionHeaders: [String] = []
    
    init() {
        let layout = PinterestLayout()
        super.init(collectionViewLayout: layout)
        layout.delegate = self
        setupData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        title = "Pinterest Tree Demo"
        
        // Add toolbar with demo actions
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Refresh",
            style: .plain,
            target: self,
            action: #selector(refreshData)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Expand All",
            style: .plain,
            target: self,
            action: #selector(toggleExpandAll)
        )
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.alwaysBounceVertical = true
        
        // Register cells and headers
        collectionView.register(PinterestTreeCell.self, forCellWithReuseIdentifier: "PinterestTreeCell")
        collectionView.register(
            PinterestSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "PinterestSectionHeader"
        )
        
        // Add pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        setupData()
        collectionView.reloadData()
        collectionView.refreshControl?.endRefreshing()
    }
    
    @objc private func toggleExpandAll() {
        guard let root = treeRoot else { return }
        
        let shouldExpand = !root.children.allSatisfy { $0.isExpanded }
        toggleExpansionRecursively(node: root, expand: shouldExpand)
        
        navigationItem.leftBarButtonItem?.title = shouldExpand ? "Collapse All" : "Expand All"
        
        rebuildDisplayData()
        collectionView.reloadData()
    }
    
    private func toggleExpansionRecursively(node: PinNode, expand: Bool) {
        node.isExpanded = expand
        node.children.forEach { toggleExpansionRecursively(node: $0, expand: expand) }
    }
    
    private func setupData() {
        treeRoot = PinContent.createSampleTree()
        rebuildDisplayData()
    }
    
    private func rebuildDisplayData() {
        displayData.removeAll()
        sectionHeaders.removeAll()
        
        guard let root = treeRoot else { return }
        
        var sectionIndex = 0
        
        // Process each depth level as a section
        var levelNodes: [Int: [PinNode]] = [:]
        collectVisibleNodes(node: root, level: 0, nodes: &levelNodes)
        
        let maxLevel = levelNodes.keys.max() ?? 0
        for level in 0...maxLevel {
            if let nodes = levelNodes[level], !nodes.isEmpty {
                let headerTitle = level == 0 ? "Pinterest Home" : "Level \(level)"
                sectionHeaders.append(headerTitle)
                
                for node in nodes {
                    displayData.append((node: node, section: sectionIndex, isVisible: true))
                }
                sectionIndex += 1
            }
        }
    }
    
    private func collectVisibleNodes(node: PinNode, level: Int, nodes: inout [Int: [PinNode]]) {
        if nodes[level] == nil {
            nodes[level] = []
        }
        nodes[level]?.append(node)
        
        if node.isExpanded {
            node.children.forEach { child in
                collectVisibleNodes(node: child, level: level + 1, nodes: &nodes)
            }
        }
    }
    
    // MARK: - PinterestLayoutDelegate
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let item = getDisplayItem(at: indexPath)
        let baseHeight: CGFloat = 140
        let aspectRatio = item.node.value.imageAspectRatio
        let calculatedHeight = baseHeight * aspectRatio
        
        // Add extra height for text content and depth indicator
        let textHeight: CGFloat = 60 + CGFloat(item.node.depth * 8)
        
        return calculatedHeight + textHeight
    }
    
    private func getDisplayItem(at indexPath: IndexPath) -> (node: PinNode, section: Int, isVisible: Bool) {
        let itemsInSection = displayData.filter { $0.section == indexPath.section }
        return itemsInSection[indexPath.item]
    }
    
    // MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionHeaders.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayData.filter { $0.section == section }.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PinterestTreeCell", for: indexPath) as! PinterestTreeCell
        let item = getDisplayItem(at: indexPath)
        cell.configure(with: item.node)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "PinterestSectionHeader",
                for: indexPath
            ) as! PinterestSectionHeader
            
            header.configure(with: sectionHeaders[indexPath.section])
            return header
        }
        return UICollectionReusableView()
    }
    
    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = getDisplayItem(at: indexPath)
        let node = item.node
        
        // Toggle expansion if node has children
        if !node.children.isEmpty {
            node.toggleExpansion()
            rebuildDisplayData()
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.3)
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.reloadData() // ✅ Safe reload with animation
            CATransaction.commit()
        } else {
            // Show detail for leaf nodes
            showPinDetail(for: node)
        }
    }
    
    private func showPinDetail(for node: PinNode) {
        let alert = UIAlertController(
            title: node.value.title,
            message: """
            Category: \(node.value.category)
            Board: \(node.value.boardName ?? "None")
            Saves: \(node.value.saveCount)
            Tree Depth: \(node.depth)
            Children: \(node.children.count)
            
            \(node.value.description)
            """,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Save Pin", style: .default) { _ in
            // Simulate saving pin
            self.showToast(message: "Pin saved!")
        })
        
        alert.addAction(UIAlertAction(title: "Share", style: .default) { _ in
            // Simulate sharing
            self.showToast(message: "Pin shared!")
        })
        
        alert.addAction(UIAlertAction(title: "Close", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showToast(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true)
        }
    }
}

// MARK: - Pinterest Style Custom Layout
class PinterestLayout: UICollectionViewLayout {
    // Layout configuration
    weak var delegate: PinterestLayoutDelegate?
    
    private var numberOfColumns = 3
    private var cellPadding: CGFloat = 8
    private var headerHeight: CGFloat = 50
    
    // Cache
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty,
              let collectionView = collectionView else { return }
        
        let columnWidth = (contentWidth - CGFloat(numberOfColumns + 1) * cellPadding) / CGFloat(numberOfColumns)
        var columnHeights: [CGFloat] = Array(repeating: cellPadding, count: numberOfColumns)
        
        for section in 0..<collectionView.numberOfSections {
            // Section header
            if collectionView.numberOfItems(inSection: section) > 0 {
                let headerIndexPath = IndexPath(item: 0, section: section)
                let headerHeight = self.headerHeight
                let headerY = columnHeights.max()! + cellPadding
                
                let headerFrame = CGRect(
                    x: cellPadding,
                    y: headerY,
                    width: contentWidth - 2 * cellPadding,
                    height: headerHeight
                )
                
                let headerAttributes = UICollectionViewLayoutAttributes(
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    with: headerIndexPath
                )
                headerAttributes.frame = headerFrame
                cache.append(headerAttributes)
                
                // Update column heights
                let newHeight = headerFrame.maxY + cellPadding
                columnHeights = columnHeights.map { _ in newHeight }
            }
            
            // Section items
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                
                let photoHeight = delegate?.collectionView(
                    collectionView,
                    heightForPhotoAtIndexPath: indexPath
                ) ?? 120
                
                let height = cellPadding * 2 + photoHeight
                let shortestColumnIndex = columnHeights.enumerated().min { $0.element < $1.element }?.offset ?? 0
                
                let frame = CGRect(
                    x: cellPadding + (columnWidth + cellPadding) * CGFloat(shortestColumnIndex),
                    y: columnHeights[shortestColumnIndex],
                    width: columnWidth,
                    height: height
                )
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                cache.append(attributes)
                
                columnHeights[shortestColumnIndex] = frame.maxY + cellPadding
            }
        }
        
        contentHeight = columnHeights.max() ?? 0
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache.first { $0.indexPath == indexPath && $0.representedElementCategory == .cell }
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache.first {
            $0.indexPath == indexPath && $0.representedElementKind == elementKind
        }
    }
    
    override func invalidateLayout() {
        cache.removeAll()
        contentHeight = 0
        super.invalidateLayout()
    }
}

// MARK: - Pinterest Layout Delegate
protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}
