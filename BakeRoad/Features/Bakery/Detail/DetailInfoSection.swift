//
//  DetailInfoSection.swift
//  BakeRoad
//
//  Created by 이현호 on 7/28/25.
//

import SwiftUI

struct DetailInfoSection: View {
    let bakeryDetail: BakeryDetail

    var body: some View {
        Section {
            BakeryImageSliderView(
                imageUrls: bakeryDetail.imageUrls,
                openStatus: bakeryDetail.openStatus
            )
            BakeryInfoView(bakery: bakeryDetail)
        }
        .id(DetailTab.home)
        .padding(.bottom, 20)

        Rectangle()
            .frame(height: 8)
            .foregroundColor(.gray50)
    }
}
