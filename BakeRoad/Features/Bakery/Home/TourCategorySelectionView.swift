//
//  TourCategorySelectionView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/16/25.
//

import SwiftUI

struct TourCategorySelectionView: View {
    let categories: [TourCategory]
    let selectedIDs: Set<String>
    let onToggle: (String) -> Void

    var body: some View {
        HStack(spacing: 8) {
            ForEach(categories) { category in
                let isSelected = selectedIDs.contains(category.id)
                BakeRoadChip(
                    title: category.title,
                    color: .sub,
                    size: .large,
                    style: isSelected ? .fill : .weak
                )
                .onTapGesture {
                    onToggle(category.id)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
