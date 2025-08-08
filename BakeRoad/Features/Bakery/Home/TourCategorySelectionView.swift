//
//  TourCategorySelectionView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/16/25.
//

import SwiftUI

struct TourCategorySelectionView: View {
    let selectedIDs: Set<String>
    let onToggle: (String) -> Void

    var body: some View {
        HStack(spacing: 8) {
            ForEach(TourCategory.allCases, id: \.self) { category in
                let isSelected = selectedIDs.contains(category.rawValue)
                BakeRoadChip(
                    title: category.title,
                    color: .sub,
                    size: .large,
                    style: isSelected ? .fill : .weak
                )
                .onTapGesture {
                    onToggle(category.rawValue)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
