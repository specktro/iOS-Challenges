//
//  TableViewContainer.swift
//  InterestingChallenges
//
//  Created by specktro on 16/09/25.
//

import SwiftUI

struct TableViewContainer: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = TableView()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
