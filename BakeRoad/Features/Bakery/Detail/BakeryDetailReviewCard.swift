//
//  BakeryDetailReviewCard.swift
//  BakeRoad
//
//  Created by 이현호 on 7/27/25.
//

import SwiftUI

struct BakeryDetailReviewCard: View {
    let review: BakeryReview
    let onLikeTapped: (Int) -> Void
    let reviewBaseURL = "https://rmpwbqnjauejvolxmamj.supabase.co/storage/v1/object/public/bread-bucket/images/"
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Group {
                        if let img = review.profileImageURL,
                           let url = URL(string: img) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                default:
                                    Image("person")
                                        .resizable()
                                        .padding(7)
                                }
                            }
                        } else {
                            Image("person")
                                .resizable()
                                .padding(7)
                        }
                    }
                    .background(Color.primary50)
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.gray100, lineWidth: 1)
                    )
                    
                    Text(review.userName)
                        .font(.body2xsmallRegular)
                        .foregroundColor(.gray600)
                    
                    Spacer()
                    
                    Image("fillStar")
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text(String(format: "%.1f", review.rating))
                        .font(.bodyXsmallMedium)
                        .foregroundColor(.gray950)
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
                
                Text(review.content)
                    .font(.bodyXsmallRegular)
                    .foregroundColor(.gray700)
                
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
                
                Button(action: {
                    onLikeTapped(review.id)
                }) {
                    HStack(spacing: 4) {
                        let isLikedColor = review.isLike ? Color.primary500 : Color.gray300
                        
                        Image(systemName: "heart.fill")
                            .foregroundColor(isLikedColor)
                        
                        Text(review.likeCount > 0 ? "\(review.likeCount)" : "좋아요")
                            .font(.bodyXsmallRegular)
                            .foregroundColor(isLikedColor)
                    }
                }
            }
            .padding(12)
        }
        .background(Color.gray40)
        .cornerRadius(12)
        .padding(.horizontal, 12)
    }
}
