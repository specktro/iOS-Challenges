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
        let viewController = ContainerView()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
