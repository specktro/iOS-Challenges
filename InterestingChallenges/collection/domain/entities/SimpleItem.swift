//
//  SimpleItem.swift
//  InterestingChallenges
//
//  Created by specktro on 13/09/25.
//

import Foundation

// MARK: - Simple Item Model
struct SimpleItem {
    let id: String
    let title: String
    
    static func createSampleTree() -> TreeNode<SimpleItem> {
        // Root
        let root = TreeNode(value: SimpleItem(id: "root", title: "Root"))
        
        // Level 1 - Main categories
        let categories = [
            SimpleItem(id: "fruits", title: "Fruits"),
            SimpleItem(id: "vegetables", title: "Vegetables"),
            SimpleItem(id: "grains", title: "Grains")
        ]
        
        categories.forEach { item in
            let categoryNode = TreeNode(value: item)
            root.addChild(categoryNode)
            
            // Level 2 - Subcategories
            switch item.id {
            case "fruits":
                let fruits = [
                    SimpleItem(id: "citrus", title: "Citrus"),
                    SimpleItem(id: "berries", title: "Berries"),
                    SimpleItem(id: "tropical", title: "Tropical")
                ]
                fruits.forEach { fruit in
                    let fruitNode = TreeNode(value: fruit)
                    categoryNode.addChild(fruitNode)
                    
                    // Level 3 - Specific items
                    if fruit.id == "citrus" {
                        let citrusFruits = [
                            SimpleItem(id: "orange", title: "Orange"),
                            SimpleItem(id: "lemon", title: "Lemon"),
                            SimpleItem(id: "lime", title: "Lime")
                        ]
                        citrusFruits.forEach { citrus in
                            fruitNode.addChild(TreeNode(value: citrus))
                        }
                    } else if fruit.id == "berries" {
                        let berries = [
                            SimpleItem(id: "strawberry", title: "Strawberry"),
                            SimpleItem(id: "blueberry", title: "Blueberry")
                        ]
                        berries.forEach { berry in
                            fruitNode.addChild(TreeNode(value: berry))
                        }
                    }
                }
                
            case "vegetables":
                let vegetables = [
                    SimpleItem(id: "leafy", title: "Leafy Greens"),
                    SimpleItem(id: "root", title: "Root Vegetables")
                ]
                vegetables.forEach { vegetable in
                    let vegNode = TreeNode(value: vegetable)
                    categoryNode.addChild(vegNode)
                    
                    if vegetable.id == "leafy" {
                        let leafyVegs = [
                            SimpleItem(id: "spinach", title: "Spinach"),
                            SimpleItem(id: "lettuce", title: "Lettuce")
                        ]
                        leafyVegs.forEach { leafy in
                            vegNode.addChild(TreeNode(value: leafy))
                        }
                    }
                }
                
            case "grains":
                let grains = [
                    SimpleItem(id: "wheat", title: "Wheat"),
                    SimpleItem(id: "rice", title: "Rice"),
                    SimpleItem(id: "oats", title: "Oats")
                ]
                grains.forEach { grain in
                    categoryNode.addChild(TreeNode(value: grain))
                }
                
            default:
                break
            }
        }
        
        return root
    }
}

typealias SimpleNode = TreeNode<SimpleItem>
