//
//  BakeRoadLineChip.swift
//  BakeRoad
//
//  Created by 이현호 on 7/15/25.
//

import SwiftUI

struct BakeRoadLineChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(isSelected ? .body2xsmallSemibold : .body2xsmallMedium)
                .foregroundColor(isSelected ? .primary500 : .gray200)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(
                    Capsule()
                        .strokeBorder(isSelected ? Color.primary500 : Color.gray100, lineWidth: 1)
                )
        }
    }
}
