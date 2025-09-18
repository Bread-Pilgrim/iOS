//
//  DetailTourSection.swift
//  BakeRoad
//
//  Created by 이현호 on 7/28/25.
//

import SwiftUI

struct DetailTourSection: View {
    let tours: [TourInfo]
    @Binding var selectedTab: DetailTab
    @Binding var scrollPosition: ScrollPosition
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if selectedTab == .home {
                Text("근처 추천 관광지")
                    .font(.bodyLargeSemibold)
                    .foregroundColor(.gray990)
                
                ScrollView(.horizontal) {
                    HStack(alignment: .top, spacing: 12) {
                        ForEach(tours) { tour in
                            NearRecommnedTourCard(tour: tour)
                                .onTapGesture {
                                    openKakaoMap(latitude: tour.mapy, longitude: tour.mapx)
                                }
                        }
                    }
                }
                
                BakeRoadOutlinedButton(
                    title: "관광지 전체보기",
                    style: .assistive,
                    size: .medium
                ) {
                    selectedTab = .tour
                    scrollPosition.scrollTo(id: 1, anchor: .bottom)
                }
                .frame(maxWidth: .infinity)
            } else {
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(displayedTours) { tour in
                            RecommendTourCard(
                                title: tour.title,
                                address: tour.address,
                                imageUrl: tour.imageUrl,
                                categoryName: tour.categoryName
                            )
                            .onTapGesture {
                                openKakaoMap(latitude: tour.mapy, longitude: tour.mapx)
                            }
                        }
                    }
                }
                .padding(.top, 20)
            }
        }
        .padding(.horizontal, 16)
        .id(DetailTab.tour)
    }
    
    private var displayedTours: [TourInfo] {
        selectedTab == .home ? Array(tours.prefix(5)) : tours
    }
    
    private func openKakaoMap(latitude: Double, longitude: Double) {
        let urlString = "kakaomap://look?p=\(latitude),\(longitude)"
        
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                if let appStoreURL = URL(string: "https://apps.apple.com/kr/app/kakaomap/id304608425") {
                    UIApplication.shared.open(appStoreURL)
                }
            }
        }
    }
}
