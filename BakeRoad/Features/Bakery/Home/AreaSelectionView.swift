//
//  AreaSelectionView.swift
//  BakeRoad
//
//  Created by 이현호 on 7/16/25.
//

import SwiftUI

struct AreaSelectionView: View {
    let areas: [Area]
    let selectedAreaCodes: Set<Int>
    let onToggle: (Int) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(areas) { area in
                    let isSelected = selectedAreaCodes.contains(area.id)
                    let isOnlyOne = selectedAreaCodes.count == 1 && selectedAreaCodes.contains(area.id)
                    BakeRoadLineChip(
                        title: area.name,
                        isSelected: isSelected,
                        action: {
                            onToggle(area.id)
                        }
                    )
                    .disabled(isOnlyOne)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
