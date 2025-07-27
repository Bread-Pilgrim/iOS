//
//  BakeryDetailView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/27/25.
//

import SwiftUI

struct BakeryDetailView: View {
    let bakeryDetail: BakeryDetail
    let bakeryReviewList: [BakeryReview]
    let nearRecommendTour: [TourItem]
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 20) {
                BakeryImageSliderView(
                    imageUrls: bakeryDetail.imageUrls,
                    openStatus: bakeryDetail.openStatus
                )
                
                BakeryInfoView(bakery: bakeryDetail)
                
                Rectangle()
                    .frame(height: 8)
                    .foregroundColor(.gray50)
                
                // 추천 메뉴
                VStack(alignment: .leading, spacing: 16) {
                    Text("추천 메뉴")
                        .font(.bodyLargeSemibold)
                        .foregroundColor(.gray990)
                        .padding(.horizontal, 16)
                    
                    ForEach(bakeryDetail.menus.indices, id: \.self) { index in
                        RecommendMenuCard(menu: bakeryDetail.menus[index])
                        if index < bakeryDetail.menus.count - 1 {
                            Divider()
                                .background(Color.gray50)
                                .padding(.horizontal, 16)
                        }
                    }
                    
                    BakeRoadOutlinedButton(
                        title: "메뉴 전체보기",
                        style: .assistive,
                        size: .medium) {
                            print("메뉴 전체보기")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                }
                
                Rectangle()
                    .frame(height: 8)
                    .foregroundColor(.gray50)
                
                // 방문자 리뷰
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
                        ForEach(bakeryReviewList) { review in
                            BakeryDetailReviewCard(review: review)
                        }
                        
                        BakeRoadOutlinedButton(
                            title: "리뷰 전체보기",
                            style: .assistive,
                            size: .medium) {
                                print("리뷰 전체보기")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 16)
                    }
                }
                
                Rectangle()
                    .frame(height: 8)
                    .foregroundColor(.gray50)
                
                // 근처 추천 관광지
                VStack(alignment: .leading, spacing: 16) {
                    Text("근처 추천 관광지")
                        .font(.bodyLargeSemibold)
                        .foregroundColor(.gray990)
                    
                    ScrollView(.horizontal) {
                        HStack(alignment: .top, spacing: 12) {
                            ForEach(nearRecommendTour) { tour in
                                NearRecommnedTourCard(tour: tour)
                            }
                        }
                    }
                    
                    BakeRoadOutlinedButton(
                        title: "관광지 전체보기",
                        style: .assistive,
                        size: .medium) {
                            print("관광지 전체보기")
                        }
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

#Preview {
    BakeryDetailView(
        bakeryDetail: BakeryDetail.mockData,
        bakeryReviewList: BakeryReview.mocks,
        nearRecommendTour: TourItem.mockData
    )
}
