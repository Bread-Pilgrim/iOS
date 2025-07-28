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
    
    @State private var showTabHeader = false
    
    enum Tab: String, CaseIterable {
        case home = "홈"
        case menu = "메뉴"
        case review = "리뷰"
        case tour = "근처 관광지"
    }
    
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section {
                    BakeryImageSliderView(
                        imageUrls: bakeryDetail.imageUrls,
                        openStatus: bakeryDetail.openStatus
                    )
                    BakeryInfoView(bakery: bakeryDetail)
                }
                .id(Tab.home)
                .padding(.bottom, 20)
                
                Rectangle()
                    .frame(height: 8)
                    .foregroundColor(.gray50)
                
                Section(header: tabHeaderView) {
                    // 추천 메뉴
                    VStack(alignment: .leading, spacing: 16) {
                        Text("추천 메뉴")
                            .font(.bodyLargeSemibold)
                            .foregroundColor(.gray990)
                            .padding(.horizontal, 16)
                            .padding(.top, 20)
                        
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
                            size: .medium
                        ) {
                            selectedTab = .menu
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                    }
                    .id(Tab.menu)
                    .padding(.bottom, 20)
                    
                    Rectangle()
                        .frame(height: 8)
                        .foregroundColor(.gray50)
                        .padding(.bottom, 20)
                    
                    // 리뷰
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
                                size: .medium
                            ) {
                                selectedTab = .review
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 16)
                        }
                    }
                    .id(Tab.review)
                    .padding(.bottom, 20)
                    
                    Rectangle()
                        .frame(height: 8)
                        .foregroundColor(.gray50)
                        .padding(.bottom, 20)
                    
                    // 근처 관광지
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
                            size: .medium
                        ) {
                            selectedTab = .tour
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 16)
                    .id(Tab.tour)
                }
            }
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ViewOffsetKey.self) { value in
            withAnimation {
                print(value)
                showTabHeader = value < 50  // 원하는 시점에서 보여지게
            }
        }
        .clipped()
    }
    
    private var infoHeader: some View {
        HeaderView {
            Button {
                print("뒤로가기")
            } label: {
                Image("arrowLeft")
            }
        } centerItem: {
            Text(bakeryDetail.name)
                .font(.headingSmallBold)
                .foregroundColor(.gray990)
        } rightItem: {
            HStack(spacing: 16) {
                Button {
                    print("공유")
                } label: {
                    Image("share")
                }
                
                Button {
                    print("뒤로가기")
                } label: {
                    Image("heart")
                }
            }
        }
    }
    
    private var tabHeaderView: some View {
        HStack(spacing: 10) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                    withAnimation {
                        scrollTo(tab)
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(tab.rawValue)
                            .font(.bodyMediumSemibold)
                            .foregroundColor(selectedTab == tab ? .gray990 : .gray200)
                            .overlay(
                                
                                Rectangle()
                                    .fill(selectedTab == tab ? Color.gray990 : Color.gray50)
                                    .frame(height: selectedTab == tab ? 1 : 0),
                                alignment: .bottom
                            )
                        //                        if selectedTab == tab {
                        //                            Rectangle()
                        //                                .fill(Color.black)
                        //                                .frame(height: 1)
                        //                        } else {
                        //                            Rectangle()
                        //                                .fill(Color.clear)
                        //                                .frame(height: 1)
                        //                        }
                    }
                }
            }
        }
        .frame(height: 42)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .background(Color.white)
    }
    
    private func scrollTo(_ tab: Tab) {
        // 실제 스크롤 처리는 ScrollViewReader 블록 안에서 실행되므로
        // scrollTo 동작은 각 탭 버튼 안에서 직접 수행해야 합니다.
    }
}

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    BakeryDetailView(
        bakeryDetail: BakeryDetail.mockData,
        bakeryReviewList: BakeryReview.mocks,
        nearRecommendTour: TourItem.mockData
    )
}
