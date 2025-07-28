//
//  DetailReviewSection.swift
//  BakeRoad
//
//  Created by 이현호 on 7/28/25.
//

import SwiftUI

struct DetailReviewSection: View {
    let bakeryDetail: BakeryDetail
    let reviews: [BakeryReview]
    @Binding var selectedTab: DetailTab

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 0) {
                Text("방문자 리뷰")
                    .font(.bodyLargeSemibold)
                    .foregroundColor(.gray990)
                    .padding(.trailing, 2)

                Text("(\(bakeryDetail.reviewCount))")
                    .font(.bodySmallMedium)
                    .foregroundColor(.gray990)

                Spacer()

                Image("reviewStar")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 5)

                Text(String(format: "%.1f", bakeryDetail.rating))
                    .font(.bodyMediumSemibold)
                    .foregroundColor(.gray950)
            }
            .padding(.horizontal, 16)

            if bakeryDetail.reviewCount == 0 {
                ZStack {
                    Rectangle()
                        .fill(Color.gray40)
                        .cornerRadius(12)

                    Text("아직 등록된 리뷰가 없습니다!\n방문하셨다면 리뷰를 남겨주세요 🥨")
                        .font(.bodyXsmallRegular)
                        .foregroundColor(.gray600)
                        .padding(.vertical, 40)
                }
                .padding(.horizontal, 16)
            } else {
                ForEach(reviews) { review in
                    BakeryDetailReviewCard(review: review)
                }

                if selectedTab == .home {
                    BakeRoadOutlinedButton(
                        title: "리뷰 전체보기",
                        style: .assistive,
                        size: .medium
                    ) {
                        selectedTab = .review
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                }
            }
        }
        .id(DetailTab.review)
        .padding(.bottom, 20)

        Rectangle()
            .frame(height: 8)
            .foregroundColor(.gray50)
            .padding(.bottom, 20)
    }
}

#Preview {
    DetailReviewSection(
        bakeryDetail: BakeryDetail.mockData,
        reviews: BakeryReview.mocks,
        selectedTab: .constant(.review)
    )
}
