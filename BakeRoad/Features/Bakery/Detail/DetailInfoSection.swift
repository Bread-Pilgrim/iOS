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
    let onBackButtonTap: () -> Void

    var body: some View {
        Section {
            BakeryImageSliderView(
                imageUrls: bakeryDetail.imageUrls,
                openStatus: bakeryDetail.openStatus,
                onBackButtonTap: onBackButtonTap
            )
            BakeryInfoView(bakery: bakeryDetail,
                           reviewData: reviewData)
        }
        .id(DetailTab.home)
        .padding(.bottom, 20)

        Rectangle()
            .frame(height: 8)
            .foregroundColor(.gray50)
    }
}
