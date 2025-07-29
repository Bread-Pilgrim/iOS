//
//  RecommendTourCard.swift
//  BakeRoad
//
//  Created by 이현호 on 7/17/25.
//

import SwiftUI

struct RecommendTourCard: View {
    let title: String
    let address: String
    let imageUrl: String
    let categoryName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            BakeryImageView(
                imageUrl: imageUrl,
                placeholder: .ratio16_9
            )
            .frame(maxWidth: .infinity)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    BakeRoadChip(
                        title: categoryName,
                        color: .main,
                        size: .small,
                        style: .weak
                    )
                    
                    Text(title)
                        .font(.bodyMediumSemibold)
                        .foregroundColor(.gray990)
                        .lineLimit(1)
                }
                
                Text(address)
                    .font(.body2xsmallRegular)
                    .foregroundColor(.gray400)
                    .lineLimit(1)
            }
        }
    }
}

#Preview {
    @Previewable
    @State var items = TourItem.mockData
    
    ScrollView {
        VStack(spacing: 20) {
            ForEach(items, id: \.title) { item in
                RecommendTourCard(
                    title: item.title,
                    address: item.address,
                    imageUrl: item.imageUrl,
                    categoryName: item.categoryName
                )
            }
        }
    }
    .padding(.horizontal, 16)
}
