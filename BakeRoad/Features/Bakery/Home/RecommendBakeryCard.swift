//
//  RecommendBakeryCard.swift
//  BakeRoad
//
//  Created by 이현호 on 7/16/25.
//

import SwiftUI

struct RecommendBakeryCard: View {
    let recommendBakery: RecommendBakery
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            BakeryImageView(
                imageUrl: recommendBakery.imgUrl,
                placeholder: .ratio1_1
            )
            .frame(width: 116, height: 116)
            .cornerRadius(12)
            
            Text(recommendBakery.name)
                .font(.bodyXsmallSemibold)
                .foregroundColor(.gray990)
            
            HStack(spacing: 0) {
                Image("fillStar")
                    .resizable()
                    .frame(width: 14, height: 14)
                Text(String(format: "%.1f", recommendBakery.avgRating))
                    .font(.body2xsmallMedium)
                    .foregroundColor(.gray950)
                    .padding(.leading, 4)
                Text("(\(recommendBakery.reviewCount.formattedWithSeparator))")
                    .font(.body2xsmallRegular)
                    .foregroundColor(.gray400)
                    .padding(.leading, 2)
            }
            
            BakeryOpenStatusChip(openStatus: BakeryOpenStatus(rawValue: recommendBakery.openStatus), style: .weak)
        }
    }
}
