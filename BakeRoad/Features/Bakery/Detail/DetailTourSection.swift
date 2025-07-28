//
//  DetailTourSection.swift
//  BakeRoad
//
//  Created by 이현호 on 7/28/25.
//

import SwiftUI

struct DetailTourSection: View {
    let tours: [TourItem]
    @Binding var selectedTab: DetailTab

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("근처 추천 관광지")
                .font(.bodyLargeSemibold)
                .foregroundColor(.gray990)

            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(tours) { tour in
                        NearRecommnedTourCard(tour: tour)
                    }
                }
            }

            if selectedTab == .home {
                BakeRoadOutlinedButton(
                    title: "관광지 전체보기",
                    style: .assistive,
                    size: .medium
                ) {
                    selectedTab = .tour
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 16)
        .id(DetailTab.tour)
    }
}
