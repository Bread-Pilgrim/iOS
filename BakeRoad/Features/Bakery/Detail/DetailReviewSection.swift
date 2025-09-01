//
//  DetailReviewSection.swift
//  BakeRoad
//
//  Created by 이현호 on 7/28/25.
//

import SwiftUI

struct DetailReviewSection: View {
    let reviewData: BakeryReviewData
    
    @Binding var selectedTab: DetailTab
    @ObservedObject var viewModel: BakeryDetailViewModel
    
    @State private var selectedReviewType = 0
    @State private var isShowingSortSheet = false
    @State private var selectedSortOption: SortOption = .like
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if selectedTab == .review {
                BakeRoadSegmentedControl(
                    types: [
                        "방문자 리뷰 (\(reviewData.reviewCount.formattedWithSeparator)개) ",
                        "내가 쓴 리뷰"
                    ],
                    selectedIndex: $selectedReviewType)
                .padding(.horizontal, 20)
            }
            
            HStack(spacing: 0) {
                if selectedTab == .review && selectedReviewType == 1 {
                    Text("내가 쓴 리뷰")
                        .font(.bodyLargeSemibold)
                        .foregroundColor(.black)
                } else {
                    Text("방문자 리뷰")
                        .font(.bodyLargeSemibold)
                        .foregroundColor(.black)
                        .padding(.trailing, 2)
                    
                    Text("(\(reviewData.reviewCount))")
                        .font(.bodySmallMedium)
                        .foregroundColor(.gray990)
                }
                
                Spacer()
                
                if selectedTab == .home {
                    Image("fillStar")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 5)
                    
                    Text(String(format: "%.1f", reviewData.avgRating))
                        .font(.bodyMediumSemibold)
                        .foregroundColor(.gray950)
                } else {
                    BakeRoadOutlinedButton(
                        title: "리뷰 작성하기",
                        style: .assistive,
                        size: .small
                    ) {
                        viewModel.didTapReviewWriteButton()
                    }
                    .frame(width: 95)
                }
            }
            .padding(.horizontal, 16)
            
            if !viewModel.reviews.isEmpty && selectedTab == .review && selectedReviewType == 0 {
                HStack(spacing: 0) {
                    Image("fillStar")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 5)
                    
                    Text(String(format: "%.1f", reviewData.avgRating))
                        .font(.bodyMediumSemibold)
                        .foregroundColor(.gray950)
                    
                    Spacer()
                    
                    BakeRoadTextButton(
                        title: selectedSortOption.displayTitle(),
                        type: .assistive,
                        size: .small) {
                            isShowingSortSheet = true
                        }
                        .sheet(isPresented: $isShowingSortSheet) {
                            SortOptionSheet(
                                selectedOption: $selectedSortOption,
                                options: [.like, .newest, .ratingHigh, .ratingLow],
                                isMyBakery: false,
                                onConfirm: {
                                    isShowingSortSheet = false
                                    // 정렬 옵션 변경 시 API 재호출
                                    Task {
                                        await viewModel.changeSortOption(selectedSortOption)
                                    }
                                },
                                onCancel: {
                                    isShowingSortSheet = false
                                }
                            )
                            .presentationDetents([.fraction(0.42)])
                        }
                }
                .padding(.horizontal, 16)
            }
            
            if viewModel.reviews.isEmpty {
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
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.reviews.indices, id: \.self) { index in
                        let review = viewModel.reviews[index]
                        BakeryDetailReviewCard(review: review) { reviewId in
                            viewModel.didTapReviewLikeButton(reviewId)
                        }
                        .onAppear {
                            // 리뷰탭에서만 페이징 트리거 (마지막 2개 아이템에서)
                            if selectedTab == .review && 
                               index >= max(0, viewModel.reviews.count - 2) &&
                               viewModel.hasNextReviews {
                                Task {
                                    await viewModel.loadMoreReviewsOnScroll()
                                }
                            }
                        }
                    }
                    
                    // 로딩 인디케이터
                    if viewModel.hasNextReviews && selectedTab == .review {
                        ProgressView()
                            .frame(height: 50)
                            .onAppear {
                                Task {
                                    await viewModel.loadMoreReviewsOnScroll()
                                }
                            }
                    }
                }
                
                if selectedTab == .home {
                    BakeRoadOutlinedButton(
                        title: "리뷰 전체보기",
                        style: .assistive,
                        size: .medium
                    ) {
                        selectedTab = .review
                        Task {
                            await viewModel.loadReviews(type: .visitor)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                }
            }
        }
        .id(DetailTab.review)
        .padding(.bottom, 20)
        .onChange(of: selectedReviewType) { oldValue, newValue in
            if selectedTab == .review {
                Task {
                    if newValue == 0 {
                        // 방문자 리뷰
                        await viewModel.loadReviews(type: .visitor, sortOption: selectedSortOption)
                    } else {
                        // 내가 쓴 리뷰
                        await viewModel.loadReviews(type: .my)
                    }
                }
            }
        }
        
        if selectedTab == .home {
            Rectangle()
                .frame(height: 8)
                .foregroundColor(.gray50)
                .padding(.bottom, 20)
        }
    }
}
