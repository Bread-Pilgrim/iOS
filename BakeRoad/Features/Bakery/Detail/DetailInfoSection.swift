//
//  DetailInfoSection.swift
//  BakeRoad
//
//  Created by 이현호 on 7/28/25.
//

import SwiftUI

struct DetailInfoSection: View {
    let bakeryDetail: BakeryDetail
    let reviewData: BakeryReviewData
    let isLoadingLike: Bool
    let onBackButtonTap: () -> Void
    let onLikeButtonTap: () -> Void
    let onWriteButtonTap: () -> Void

    var body: some View {
        Section {
            BakeryImageSliderView(
                bakeryDetail: bakeryDetail,
                isLoadingLike: isLoadingLike,
                onBackButtonTap: onBackButtonTap,
                onLikeButtonTap: onLikeButtonTap
            )
            BakeryInfoView(
                bakery: bakeryDetail,
                reviewData: reviewData,
                onWriteButtonTap: onWriteButtonTap
            )
        }
        .id(DetailTab.home)
        .padding(.bottom, 20)

        Rectangle()
            .frame(height: 8)
            .foregroundColor(.gray50)
    }
}
