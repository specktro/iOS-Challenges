//
//  HomeView.swift
//  InterestingChallenges
//
//  Created by specktro on 08/09/25.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedCategory: Algorithm.AlgorithmCategory? = nil
    private var filteredAlgorithms: [Algorithm] {
        var algorithms = Algorithm.sampleAlgorithms
        
        // Filter by category
        if let category = selectedCategory {
            algorithms = algorithms.filter { $0.category == category }
        }
        
        return algorithms
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category filter
                if !Algorithm.AlgorithmCategory.allCases.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            // All categories button
                            CategoryFilterChip(
                                title: "All",
                                systemImage: "square.grid.2x2",
                                isSelected: selectedCategory == nil
                            ) {
                                selectedCategory = nil
                            }
                            
                            ForEach(Algorithm.AlgorithmCategory.allCases, id: \.self) { category in
                                CategoryFilterChip(
                                    title: category.rawValue,
                                    systemImage: category.systemImage,
                                    isSelected: selectedCategory == category
                                ) {
                                    selectedCategory = selectedCategory == category ? nil : category
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.vertical, 12)
                    .background(Color(UIColor.systemGroupedBackground))
                }
                
                // Algorithms list
                if filteredAlgorithms.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        
                        Text("No algorithms found")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Try adjusting your search or category filter")
                            .font(.subheadline)
                            .foregroundColor(Color(UIColor.tertiaryLabel))
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    Spacer()
                } else {
                    List(filteredAlgorithms, id: \.id) { algorithm in
                        NavigationLink(destination: algorithmDetailView(for: algorithm)) {
                            AlgorithmRowView(algorithm: algorithm)
                        }
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowBackground(Color(UIColor.systemBackground))
                    }
                    .listStyle(PlainListStyle())
                    .background(Color(UIColor.systemGroupedBackground))
                }
            }
            .navigationTitle("Algorithms")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
    
    @ViewBuilder
    private func algorithmDetailView(for algorithm: Algorithm) -> some View {
        if algorithm.title == "Tree Data Structure" && algorithm.isImplemented {
            CollectionView()
                .navigationTitle("Tree Structure")
                .navigationBarTitleDisplayMode(.inline)
        } else {
            ComingSoonView(algorithm: algorithm)
        }
    }
}

// MARK: - Supporting Views
struct CategoryFilterChip: View {
    let title: String
    let systemImage: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: systemImage)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.accentColor : Color(UIColor.systemGray6))
            .foregroundColor(isSelected ? .white : .primary)
            .clipShape(Capsule())
        }
    }
}

struct ComingSoonView: View {
    let algorithm: Algorithm
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(algorithm.color.opacity(0.15))
                    .frame(width: 100, height: 100)
                
                Image(systemName: algorithm.systemImage)
                    .font(.system(size: 48))
                    .foregroundColor(algorithm.color)
            }
            
            VStack(spacing: 12) {
                Text(algorithm.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(algorithm.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            VStack(spacing: 8) {
                HStack {
                    Label(algorithm.category.rawValue, systemImage: algorithm.category.systemImage)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(algorithm.difficulty.rawValue)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(algorithm.difficulty.color.opacity(0.15))
                        .foregroundColor(algorithm.difficulty.color)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 32)
            }
            
            Text("🚧 Implementation coming soon!")
                .font(.headline)
                .foregroundColor(.orange)
                .padding(.top, 16)
            
            Spacer()
        }
        .padding()
        .navigationTitle(algorithm.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    HomeView()
}
