//
//  UserReviewCard.swift
//  BakeRoad
//
//  Created by 이현호 on 8/26/25.
//

import SwiftUI

struct UserReviewCard: View {
    let review: UserReview
    let onDetailsTapped: (BakeryDetailFilter) -> Void
    let onLikeTapped: (Int) -> Void
    let reviewBaseURL = "https://rmpwbqnjauejvolxmamj.supabase.co/storage/v1/object/public/bread-bucket/images/"
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(review.bakeryName)
                        .font(.bodyMediumSemibold)
                        .foregroundColor(.black)
                    
                    HStack(spacing: 4) {
                        Image("fillStar")
                            .resizable()
                            .frame(width: 16, height: 16)
                        Text(String(format: "%.1f", review.reviewRating))
                            .font(.bodyXsmallMedium)
                            .foregroundColor(.gray950)
                    }
                }
                .onTapGesture {
                    onDetailsTapped(
                        BakeryDetailFilter(
                            bakeryId: review.bakeryId,
                            areaCodes: [review.commericalAreaID],
                            tourCatCodes: CategoryManager.shared.selectedCategoryCodes
                        )
                    )
                }
                
                if !review.photos.isEmpty {
                    HStack(spacing: 7) {
                        ForEach(review.photos, id: \.self) { url in
                            BakeryImageView(imageUrl: reviewBaseURL+url, placeholder: .ratio3_2)
                                .cornerRadius(8)
                                .frame(maxWidth: .infinity)
                                .frame(height: 104)
                        }
                    }
                }
                
                Text(review.reviewContent)
                    .font(.bodyXsmallRegular)
                    .foregroundColor(.gray700)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 6) {
                    ForEach(review.menus, id: \.self) { menu in
                        BakeRoadChip(
                            title: menu,
                            color: .main,
                            size: .small,
                            style: .weak
                        )
                    }
                }
                
                HStack {
                    Button {
                        onLikeTapped(review.id)
                    } label: {
                        HStack(spacing: 4) {
                            let isLikedColor = review.isLike ? Color.primary500 : Color.gray300
                            
                            Image(systemName: "heart.fill")
                                .foregroundColor(isLikedColor)
                            
                            Text(review.reviewLikeCount > 0 ? "\(review.reviewLikeCount)" : "좋아요")
                                .font(.bodyXsmallRegular)
                                .foregroundColor(isLikedColor)
                        }
                    }
                    
                    Spacer()
                    
                    if let date = extractDate(from: review.reviewCreatedAt) {
                        Text(date)
                            .font(.body2xsmallRegular)
                            .foregroundColor(.gray300)
                    }
                }
                .padding(.top, 8)
            }
            .padding(12)
        }
        .background(Color.gray40)
        .cornerRadius(12)
        .padding(.horizontal, 16)
    }
    
    private func extractDate(from isoString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = inputFormatter.date(from: isoString) else { return nil }
        return outputFormatter.string(from: date)
    }
}
