//
//  SortOptionSheet.swift
//  BakeRoad
//
//  Created by 이현호 on 7/29/25.
//

import SwiftUI

enum SortOption: String, CaseIterable, Identifiable, Encodable {
    case like = "LIKE_COUNT.DESC"
    case newest = "CREATED_AT.DESC"
    case ratingHigh = "RATING.DESC"
    case ratingLow = "RATING.ASC"
    case reviewCountHigh = "REVIEW_COUNT.DESC"
    case avgRatingHigh = "AVG_RATING.DESC"
    case avgRatingLow = "AVG_RATING.ASC"
    case name = "NAME.ASC"

    var id: String { rawValue }

    func displayTitle(isMyBakery: Bool = false) -> String {
        switch self {
        case .like: return "좋아요순"
        case .newest: return isMyBakery ? "최근 저장순" : "최신 작성순"
        case .ratingHigh: return "높은 평가순"
        case .ratingLow: return "낮은 평가순"
        case .reviewCountHigh: return "리뷰 많은 순"
        case .avgRatingHigh: return "별점 높은순"
        case .avgRatingLow: return "별점 낮은순"
        case .name: return "가나다 순"
        }
    }
}

struct SortOptionSheet: View {
    @Binding var selectedOption: SortOption
    let options: [SortOption]
    let isMyBakery: Bool
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
                ForEach(options) { option in
                    RadioButton(
                        title: option.displayTitle(isMyBakery: isMyBakery),
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
