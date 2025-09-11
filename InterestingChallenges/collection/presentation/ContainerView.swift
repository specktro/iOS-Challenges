//
//  ContainerView.swift
//  InterestingChallenges
//
//  Created by specktro on 09/09/25.
//

import UIKit

// MARK: - Main ContainerView
final class ContainerView: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
    }
    
    private func setupNavigationController() {
        // Create and embed the tree collection view controller
        let treeController = TreeCollectionView()
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
