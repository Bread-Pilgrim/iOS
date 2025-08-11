//
//  NearRecommnedTourCard.swift
//  BakeRoad
//
//  Created by 이현호 on 7/27/25.
//

import SwiftUI

struct NearRecommnedTourCard: View {
    let tour: TourInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack(alignment: .topLeading) {
                BakeryImageView(
                    imageUrl: tour.imageUrl,
                    placeholder: .ratio1_1
                )
                .frame(width: 100, height: 100)
                .cornerRadius(8)
                
                BakeRoadChip(
                    title: tour.categoryName,
                    color: .sub,
                    size: .small,
                    style: .fill
                )
                .padding(4)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(tour.title)
                    .font(.bodySmallSemibold)
                    .foregroundColor(.gray990)
                
                Text(tour.address)
                    .font(.body2xsmallRegular)
                    .foregroundColor(.gray400)
            }
        }
        .frame(width: 100)
    }
}
