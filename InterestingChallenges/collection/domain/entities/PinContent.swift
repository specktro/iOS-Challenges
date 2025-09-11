//
//  PinContent.swift
//  InterestingChallenges
//
//  Created by specktro on 10/09/25.
//

import Foundation

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
