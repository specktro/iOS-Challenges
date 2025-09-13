//
//  AlgorithmRowView.swift
//  InterestingChallenges
//
//  Created by specktro on 09/09/25.
//

import SwiftUI

struct AlgorithmRowView: View {
    let algorithm: Algorithm
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon with background
            ZStack {
                Circle()
                    .fill(algorithm.color.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: algorithm.systemImage)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(algorithm.color)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(algorithm.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    // Implementation status
                    if algorithm.isImplemented {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                    } else {
                        Image(systemName: "clock.circle.fill")
                            .foregroundColor(.orange)
                            .font(.caption)
                    }
                }
                
                Text(algorithm.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 8) {
                    // Category tag
                    Text(algorithm.category.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(UIColor.systemGray5))
                        .foregroundColor(.secondary)
                        .clipShape(Capsule())
                    
                    // Difficulty badge
                    Text(algorithm.difficulty.rawValue)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(algorithm.difficulty.color.opacity(0.15))
                        .foregroundColor(algorithm.difficulty.color)
                        .clipShape(Capsule())
                    
                    Spacer()
                }
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}

#Preview {
    List {
        ForEach(Algorithm.sampleAlgorithms.prefix(3), id: \.id) { algorithm in
            AlgorithmRowView(algorithm: algorithm)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
    }
    .listStyle(PlainListStyle())
}
