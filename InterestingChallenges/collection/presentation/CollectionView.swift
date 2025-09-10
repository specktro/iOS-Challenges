//
//  CollectionView.swift
//  InterestingChallenges
//
//  Created by specktro on 08/09/25.
//

import SwiftUI
import UIKit

struct CollectionView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = ViewController()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

// MARK: - Main ViewController
final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
    }
    
    private func setupNavigationController() {
        // Create and embed the tree collection view controller
        let treeController = TreeCollectionViewController()
        let navigationController = UINavigationController(rootViewController: treeController)
        
        // Add as child view controller
        addChild(navigationController)
        view.addSubview(navigationController.view)
        navigationController.view.frame = view.bounds
        navigationController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        navigationController.didMove(toParent: self)
        
        // Style the navigation
        setupNavigationAppearance(navigationController.navigationBar)
    }
    
    private func setupNavigationAppearance(_ navigationBar: UINavigationBar) {
        // Pinterest-style navigation
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        
        navigationBar.tintColor = .systemRed // Pinterest red
        navigationBar.prefersLargeTitles = false
    }
}

// MARK: - Tree Node Data Structure
class TreeNode<T> {
    var value: T
    var children: [TreeNode<T>]
    weak var parent: TreeNode<T>?
    var isExpanded: Bool = true
    
    init(value: T) {
        self.value = value
        self.children = []
    }
    
    func addChild(_ child: TreeNode<T>) {
        child.parent = self
        children.append(child)
    }
    
    func removeChild(_ child: TreeNode<T>) {
        children.removeAll { $0 === child }
        child.parent = nil
    }
    
    var isLeaf: Bool {
        return children.isEmpty
    }
    
    var depth: Int {
        var level = 0
        var current = parent
        while current != nil {
            level += 1
            current = current?.parent
        }
        return level
    }
    
    func toggleExpansion() {
        isExpanded.toggle()
    }
}

// MARK: - Pin Content Model
struct PinContent {
    let id: String
    let title: String
    let imageURL: String
    let description: String
    let category: String
    let boardName: String?
    let saveCount: Int
    let imageAspectRatio: CGFloat
    
    static func createSampleTree() -> TreeNode<PinContent> {
        // Root: Pinterest Home
        let root = TreeNode(value: PinContent(
            id: "root",
            title: "Pinterest Home",
            imageURL: "home",
            description: "Your personalized Pinterest feed",
            category: "Home",
            boardName: nil,
            saveCount: 0,
            imageAspectRatio: 1.0
        ))
        
        // Main Categories
        let categories = [
            ("food", "Food & Recipes", "Delicious meals and cooking inspiration", 1.3),
            ("home", "Home Decor", "Beautiful interior design ideas", 0.8),
            ("fashion", "Fashion & Style", "Trendy outfits and style inspiration", 1.5),
            ("travel", "Travel & Places", "Amazing destinations and travel tips", 0.7),
            ("diy", "DIY & Crafts", "Creative projects and handmade ideas", 1.1)
        ]
        
        for (_, (id, title, desc, ratio)) in categories.enumerated() {
            let categoryNode = TreeNode(value: PinContent(
                id: id,
                title: title,
                imageURL: id,
                description: desc,
                category: title,
                boardName: nil,
                saveCount: Int.random(in: 100...5000),
                imageAspectRatio: ratio
            ))
            
            root.addChild(categoryNode)
            
            // Add subcategories/boards for each main category
            switch id {
            case "food":
                let foodSubcategories = [
                    ("pasta", "Pasta Recipes", "Italian pasta dishes", 1.2),
                    ("desserts", "Sweet Desserts", "Cakes, cookies, and treats", 1.0),
                    ("healthy", "Healthy Meals", "Nutritious and delicious", 1.4)
                ]
                addSubcategories(to: categoryNode, subcategories: foodSubcategories, parentCategory: "Food")
                
            case "home":
                let homeSubcategories = [
                    ("living", "Living Room", "Cozy living spaces", 0.9),
                    ("kitchen", "Kitchen Design", "Modern kitchen ideas", 0.8),
                    ("bedroom", "Bedroom Decor", "Peaceful sleeping spaces", 1.1)
                ]
                addSubcategories(to: categoryNode, subcategories: homeSubcategories, parentCategory: "Home")
                
            case "fashion":
                let fashionSubcategories = [
                    ("casual", "Casual Wear", "Everyday outfit ideas", 1.6),
                    ("formal", "Formal Attire", "Elegant evening wear", 1.4),
                    ("accessories", "Accessories", "Bags, jewelry, and more", 1.0)
                ]
                addSubcategories(to: categoryNode, subcategories: fashionSubcategories, parentCategory: "Fashion")
                
            default:
                break
            }
        }
        
        return root
    }
    
    private static func addSubcategories(to parent: TreeNode<PinContent>,
                                         subcategories: [(String, String, String, Double)],
                                         parentCategory: String) {
        for (id, title, desc, ratio) in subcategories {
            let subcategoryNode = TreeNode(value: PinContent(
                id: "\(parentCategory.lowercased())_\(id)",
                title: title,
                imageURL: id,
                description: desc,
                category: parentCategory,
                boardName: title,
                saveCount: Int.random(in: 50...1000),
                imageAspectRatio: CGFloat(ratio)
            ))
            
            parent.addChild(subcategoryNode)
            
            // Add some individual pins to subcategories
            for i in 1...Int.random(in: 2...5) {
                let pinNode = TreeNode(value: PinContent(
                    id: "\(id)_pin_\(i)",
                    title: "\(title) Pin \(i)",
                    imageURL: "\(id)_\(i)",
                    description: "Amazing \(title.lowercased()) inspiration",
                    category: parentCategory,
                    boardName: title,
                    saveCount: Int.random(in: 10...500),
                    imageAspectRatio: CGFloat.random(in: 0.7...1.8)
                ))
                subcategoryNode.addChild(pinNode)
            }
        }
    }
}

typealias PinNode = TreeNode<PinContent>

// MARK: - Pinterest Style Custom Layout
class PinterestLayout: UICollectionViewLayout {
    
    // Layout configuration
    weak var delegate: PinterestLayoutDelegate?
    
    private var numberOfColumns = 2
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

// MARK: - Main Collection View Controller
class TreeCollectionViewController: UICollectionViewController, PinterestLayoutDelegate {
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
