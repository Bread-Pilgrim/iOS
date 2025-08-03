//
//  ReviewStarRatingView.swift
//  BakeRoad
//
//  Created by 이현호 on 8/3/25.
//

import SwiftUI

struct ReviewStarRatingView: View {
    @Binding var rating: Double
    let maxRating = 5
    let starSize: CGFloat = 32
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<maxRating, id: \.self) { index in
                GeometryReader { geo in
                    ZStack {
                        starImage(for: index)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: starSize, height: starSize)
                            .foregroundColor(.orange)
                    }
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                let localX = value.location.x
                                if localX < geo.size.width / 2 {
                                    rating = Double(index) + 0.5
                                } else {
                                    rating = Double(index) + 1.0
                                }
                            }
                    )
                }
                .frame(width: starSize, height: starSize)
            }
            
            Text(String(format: "%.1f", rating))
                .font(.bodyXlargeMedium)
                .foregroundColor(.gray950)
                .padding(.leading, 8)
        }
    }
    
    private func starImage(for index: Int) -> Image {
        if Double(index) + 1 <= rating {
            return Image("fillStar")
        } else if Double(index) + 0.5 <= rating {
            return Image("halfStar")
        } else {
            return Image("emptyStar")
        }
    }
}
