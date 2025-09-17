//
//  AlgorithmModel.swift
//  InterestingChallenges
//
//  Created by specktro on 09/09/25.
//

import Foundation
import SwiftUI

struct Algorithm: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let category: AlgorithmCategory
    let difficulty: Difficulty
    let systemImage: String
    let color: Color
    let isImplemented: Bool
    
    enum AlgorithmCategory: String, CaseIterable {
        case dataStructures = "Data Structures"
        case sorting = "Sorting"
        case searching = "Searching"
        case graphAlgorithms = "Graph Algorithms"
        case dynamicProgramming = "Dynamic Programming"
        
        var systemImage: String {
            switch self {
                case .dataStructures: return "square.stack.3d.down.right"
                case .sorting: return "arrow.up.arrow.down"
                case .searching: return "magnifyingglass"
                case .graphAlgorithms: return "point.3.connected.trianglepath.dotted"
                case .dynamicProgramming: return "function"
            }
        }
    }
    
    enum Difficulty: String, CaseIterable {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
        
        var color: Color {
            switch self {
                case .beginner: return .green
                case .intermediate: return .orange
                case .advanced: return .red
            }
        }
    }
}

extension Algorithm {
    static let sampleAlgorithms: [Algorithm] = [
        Algorithm(
            title: "Tree Data Structure",
            description: "Interactive tree visualization with expandable nodes using Pinterest-style layout",
            category: .dataStructures,
            difficulty: .intermediate,
            systemImage: "triangle.circle.fill",
            color: .blue,
            isImplemented: true
        ),
        Algorithm(
            title: "Table View Implementation",
            description: "A clean and efficient way to display and interact with a list of data and images",
            category: .dataStructures,
            difficulty: .advanced,
            systemImage: "tablecells.fill",
            color: .yellow,
            isImplemented: true
        ),
        Algorithm(
            title: "Binary Search Tree",
            description: "Self-balancing binary search tree with insertion, deletion, and traversal operations",
            category: .dataStructures,
            difficulty: .intermediate,
            systemImage: "triangle.inset.filled",
            color: .green,
            isImplemented: false
        ),
        Algorithm(
            title: "Quick Sort",
            description: "Efficient divide-and-conquer sorting algorithm with pivot selection visualization",
            category: .sorting,
            difficulty: .intermediate,
            systemImage: "arrow.up.arrow.down.circle",
            color: .orange,
            isImplemented: false
        ),
        Algorithm(
            title: "Merge Sort",
            description: "Stable divide-and-conquer sorting algorithm with step-by-step merging animation",
            category: .sorting,
            difficulty: .beginner,
            systemImage: "arrow.triangle.merge",
            color: .purple,
            isImplemented: false
        ),
        Algorithm(
            title: "Dijkstra's Algorithm",
            description: "Shortest path algorithm for weighted graphs with real-time path highlighting",
            category: .graphAlgorithms,
            difficulty: .advanced,
            systemImage: "point.3.filled.connected.trianglepath.dotted",
            color: .red,
            isImplemented: false
        ),
        Algorithm(
            title: "Breadth-First Search",
            description: "Graph traversal algorithm exploring nodes level by level with queue visualization",
            category: .graphAlgorithms,
            difficulty: .beginner,
            systemImage: "circle.grid.cross",
            color: .cyan,
            isImplemented: false
        ),
        Algorithm(
            title: "Dynamic Programming - Fibonacci",
            description: "Classic DP problem showing memoization vs tabulation approaches",
            category: .dynamicProgramming,
            difficulty: .beginner,
            systemImage: "function",
            color: .mint,
            isImplemented: false
        ),
        Algorithm(
            title: "Hash Table",
            description: "Key-value data structure with collision resolution strategies visualization",
            category: .dataStructures,
            difficulty: .intermediate,
            systemImage: "tablecells",
            color: .indigo,
            isImplemented: false
        )
    ]
}
