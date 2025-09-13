# InterestingChallenges

A visual algorithms playground showcasing data structures and algorithms through interactive iOS implementations using both UIKit and SwiftUI.

## Features

### Tree Data Structure Visualization
- **Interactive Tree Collection View** - Pinterest-style layout using UIKit
- **Expandable/Collapsible Nodes** - Tap to explore tree hierarchy  
- **Visual Depth Indicators** - Color-coded levels for easy navigation
- **Hierarchical Content** - Categories, subcategories, and individual items

### Current Implementations

#### Tree Structure (UIKit + Pinterest Layout)
- Custom `TreeNode<T>` generic class with parent/child relationships
- Pinterest-inspired masonry layout with custom flow
- Animated expand/collapse interactions
- Sample data: Pinterest-style content hierarchy (Food, Home Decor, Fashion, etc.)
- Visual features: depth indicators, category badges, save counts

## Project Structure

```
InterestingChallenges/
├── collection/
│   ├── domain/entities/
│   │   ├── TreeNode.swift          # Generic tree data structure
│   │   └── PinContent.swift        # Sample content model
│   └── presentation/
│       ├── TreeCollectionView.swift # Main UIKit collection view controller
│       ├── PinterestTreeCell.swift  # Custom Pinterest-style cells
│       ├── CollectionView.swift     # SwiftUI wrapper
│       └── ContainerView.swift      # View container
├── home/
│   └── ContentView.swift           # Basic SwiftUI home view
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