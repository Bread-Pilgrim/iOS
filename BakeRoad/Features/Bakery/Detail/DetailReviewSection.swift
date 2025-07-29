//
//  DetailReviewSection.swift
//  BakeRoad
//
//  Created by 이현호 on 7/28/25.
//

import SwiftUI

enum SortOption: String, CaseIterable, Identifiable {
    case like = "LIKE_COUNT.DESC"
    case newest = "CREATED_AT.DESC"
    case ratingHigh = "RATING.DESC"
    case ratingLow = "RATING.ASC"

    var id: String { rawValue }

    var displayTitle: String {
        switch self {
        case .like: return "좋아요순"
        case .newest: return "최신 작성순"
        case .ratingHigh: return "높은 평가순"
        case .ratingLow: return "낮은 평가순"
        }
    }
}

struct DetailReviewSection: View {
    let bakeryDetail: BakeryDetail
    let reviews: [BakeryReview]
    @Binding var selectedTab: DetailTab
    
    @State private var isShowingSortSheet = false
    @State private var selectedSortOption: SortOption = .like
    
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
                
                if selectedTab == .home {
                    Image("reviewStar")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 5)
                    
                    Text(String(format: "%.1f", bakeryDetail.rating))
                        .font(.bodyMediumSemibold)
                        .foregroundColor(.gray950)
                } else {
                    BakeRoadOutlinedButton(
                        title: "리뷰 작성하기",
                        style: .assistive,
                        size: .small
                    ) {
                        print("리뷰 작성")
                    }
                    .frame(width: 95)
                }
            }
            .padding(.horizontal, 16)
            
            if !reviews.isEmpty && selectedTab == .review {
                HStack(spacing: 0) {
                    Image("reviewStar")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 5)
                    
                    Text(String(format: "%.1f", bakeryDetail.rating))
                        .font(.bodyMediumSemibold)
                        .foregroundColor(.gray950)
                    
                    Spacer()
                    
                    BakeRoadTextButton(
                        title: selectedSortOption.displayTitle,
                        type: .assistive,
                        size: .small) {
                            isShowingSortSheet = true
                        }
                        .sheet(isPresented: $isShowingSortSheet) {
                            SortOptionSheet(
                                selectedOption: $selectedSortOption,
                                onConfirm: {
                                    isShowingSortSheet = false
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
        
        if selectedTab == .home {
            Rectangle()
                .frame(height: 8)
                .foregroundColor(.gray50)
                .padding(.bottom, 20)
        }
    }
}

struct SortOptionSheet: View {
    @Binding var selectedOption: SortOption
    var onConfirm: () -> Void
    var onCancel: () -> Void

    var body: some View {
        BakeRoadSheet(
            title: "정렬 순서",
            message: "",
            buttonAlignment: .horizontal,
            primaryAction: SheetAction(title: "정렬", action: onConfirm),
            secondaryAction: SheetAction(title: "취소", action: onCancel)
        ) {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(SortOption.allCases) { option in
                    RadioButton(
                        title: option.displayTitle,
                        isSelected: selectedOption == option,
                        isDisabled: false,
                        size: .normal
                    ) {
                        selectedOption = option
                    }
                }
            }
        }
    }
}

#Preview {
    DetailReviewSection(
        bakeryDetail: BakeryDetail.mockData,
        reviews: BakeryReview.mocks,
        selectedTab: .constant(.review)
    )
}
