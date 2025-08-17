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
