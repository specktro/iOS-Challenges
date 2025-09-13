# InterestingChallenges

A visual algorithms playground showcasing data structures and algorithms through interactive iOS implementations using both UIKit and SwiftUI.

## Features

### 🏠 Algorithm Catalog (Home View)
- **Comprehensive Algorithm Library** - Browse 8+ algorithms across 5 categories
- **Category Filtering** - Filter by Data Structures, Sorting, Graph Algorithms, etc.
- **Visual Algorithm Cards** - Color-coded difficulty levels and category badges
- **Implementation Status** - Track which algorithms are implemented vs coming soon

### 🌳 Tree Data Structure Visualization
- **Interactive Tree Collection View** - Pinterest-style layout using UIKit
- **Expandable/Collapsible Nodes** - Tap to explore tree hierarchy
- **Visual Depth Indicators** - Color-coded levels for easy navigation
- **Dual Data Models** - Support for both Pinterest-style content and simple hierarchical data
- **iOS 26 Compatibility** - Fixed navigation title bug for search functionality

### Current Implementations

#### Algorithm Home View (SwiftUI)
- Algorithm catalog with 8 predefined algorithms (Tree, BST, Quick Sort, Merge Sort, Dijkstra, BFS, Dynamic Programming, Hash Table)
- Category-based filtering system with visual chips
- Search functionality with iOS 26 navigation fix
- Navigation to detailed algorithm views

#### Tree Structure (UIKit + Pinterest Layout)
- Custom `TreeNode<T>` generic class with parent/child relationships
- Pinterest-inspired masonry layout with custom flow
- Animated expand/collapse interactions
- Dual sample data: Pinterest-style content hierarchy + Simple hierarchical food categorization
- Visual features: depth indicators, category badges, save counts

## Project Structure

```
InterestingChallenges/
├── collection/
│   ├── domain/entities/
│   │   ├── TreeNode.swift          # Generic tree data structure
│   │   ├── PinContent.swift        # Pinterest-style sample content model
│   │   └── SimpleItem.swift        # Simple hierarchical data model
│   └── presentation/
│       ├── TreeCollectionView.swift # Main UIKit collection view controller
│       ├── PinterestTreeCell.swift  # Custom Pinterest-style cells
│       ├── CollectionView.swift     # SwiftUI wrapper
│       └── ContainerView.swift      # View container
├── home/
│   ├── domain/entities/
│   │   └── AlgorithmModel.swift     # Algorithm data models
│   └── presentation/
│       ├── ContentView.swift        # Main algorithms catalog view
│       ├── HomeView.swift          # Alternative home view
│       └── AlgorithmRowView.swift  # Individual algorithm row component
└── resources/
    └── InterestingChallengesApp.swift # App entry point
```

## Getting Started

1. Open `InterestingChallenges.xcodeproj` in Xcode
2. Build and run the project
3. Interact with the Pinterest-style tree view:
   - Tap nodes with children to expand/collapse
   - Tap leaf nodes to view details
   - Use navigation buttons to expand/collapse all

## Architecture

- **Clean Architecture**: Domain entities separated from presentation
- **Generic Implementation**: `TreeNode<T>` works with any content type
- **Custom Layouts**: Pinterest masonry layout for dynamic cell heights
- **Hybrid Approach**: UIKit for complex layouts, SwiftUI for simple views

## Future Algorithms

This project serves as a foundation for implementing various algorithms visually:
- Sorting algorithms (bubble, quick, merge sort)
- Graph traversal (BFS, DFS)
- Path finding algorithms
- Binary trees and balanced trees
- Hash tables and collision resolution

---

**Tech Stack:** Swift, UIKit, SwiftUI, iOS 18+
