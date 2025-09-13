//
//  TreeCollectionViewController.swift
//  InterestingChallenges
//
//  Created by specktro on 09/09/25.
//

import UIKit

// MARK: - Main Collection View Controller
class TreeCollectionView: UICollectionViewController, SimpleTreeLayoutDelegate {
    private var treeRoot: SimpleNode?
    private var displayData: [(node: SimpleNode, section: Int)] = []
    private var sectionHeaders: [String] = []
    
    init() {
        let layout = SimpleTreeLayout()
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
        title = "Tree CollectionView Demo"
        
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
        
        collectionView.register(SimpleTreeCell.self, forCellWithReuseIdentifier: "SimpleTreeCell")
        collectionView.register(
            SimpleSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "SimpleSectionHeader"
        )
        
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
    
    private func toggleExpansionRecursively(node: SimpleNode, expand: Bool) {
        node.isExpanded = expand
        node.children.forEach { toggleExpansionRecursively(node: $0, expand: expand) }
    }
    
    private func setupData() {
        treeRoot = SimpleItem.createSampleTree()
        rebuildDisplayData()
    }
    
    private func rebuildDisplayData() {
        displayData.removeAll()
        sectionHeaders.removeAll()
        
        guard let root = treeRoot else { return }
        
        var sectionIndex = 0
        var levelNodes: [Int: [SimpleNode]] = [:]
        collectVisibleNodes(node: root, level: 0, nodes: &levelNodes)
        
        let maxLevel = levelNodes.keys.max() ?? 0
        for level in 0...maxLevel {
            if let nodes = levelNodes[level], !nodes.isEmpty {
                let headerTitle = level == 0 ? "Root Level" : "Level \(level)"
                sectionHeaders.append(headerTitle)
                
                for node in nodes {
                    displayData.append((node: node, section: sectionIndex))
                }
                sectionIndex += 1
            }
        }
    }
    
    private func collectVisibleNodes(node: SimpleNode, level: Int, nodes: inout [Int: [SimpleNode]]) {
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
    
    // MARK: - SimpleTreeLayoutDelegate
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        let item = getDisplayItem(at: indexPath)
        let baseHeight: CGFloat = 60
        let depthPadding = CGFloat(item.node.depth * 5)
        return baseHeight + depthPadding
    }
    
    private func getDisplayItem(at indexPath: IndexPath) -> (node: SimpleNode, section: Int) {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimpleTreeCell", for: indexPath) as! SimpleTreeCell
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
                withReuseIdentifier: "SimpleSectionHeader",
                for: indexPath
            ) as! SimpleSectionHeader
            
            header.configure(with: sectionHeaders[indexPath.section])
            return header
        }
        return UICollectionReusableView()
    }
    
    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = getDisplayItem(at: indexPath)
        let node = item.node
        
        if !node.children.isEmpty {
            node.toggleExpansion()
            
            let currentOffset = collectionView.contentOffset
            rebuildDisplayData()
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.3)
            CATransaction.setCompletionBlock {
                collectionView.setContentOffset(currentOffset, animated: false)
            }
            
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.reloadData()
            CATransaction.commit()
        } else {
            showItemDetail(for: node)
        }
    }
    
    private func showItemDetail(for node: SimpleNode) {
        let parentTitle = node.parent?.value.title ?? "None"
        let alert = UIAlertController(
            title: node.value.title,
            message: """
            Parent: \(parentTitle)
            Tree Depth: \(node.depth)
            Children: \(node.children.count)
            """,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Simple Custom Layout
class SimpleTreeLayout: UICollectionViewLayout {
    
    weak var delegate: SimpleTreeLayoutDelegate?
    
    private var numberOfColumns = 2
    private var cellPadding: CGFloat = 8
    private var headerHeight: CGFloat = 40
    
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
                
                let newHeight = headerFrame.maxY + cellPadding
                columnHeights = columnHeights.map { _ in newHeight }
            }
            
            // Section items
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                
                let height = delegate?.collectionView(
                    collectionView,
                    heightForItemAt: indexPath
                ) ?? 80
                
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

// MARK: - Layout Delegate
protocol SimpleTreeLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView,
                       heightForItemAt indexPath: IndexPath) -> CGFloat
}
