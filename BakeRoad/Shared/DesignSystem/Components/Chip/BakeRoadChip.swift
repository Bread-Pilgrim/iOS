//
//  BakeRoadChip.swift
//  BakeRoad
//
//  Created by 이현호 on 7/12/25.
//

import SwiftUI

enum ChipColor {
    case main, sub, gray, lightGray, red, success

    var backgroundColor: Color {
        switch self {
        case .main: return Color.primary500
        case .sub: return Color.secondary500
        case .gray: return Color.gray800
        case .lightGray: return Color.gray400
        case .red: return Color.error500
        case .success: return Color.success500
        }
    }

    var weakBackgroundColor: Color {
        switch self {
        case .main: return Color.primary50
        case .sub: return Color.secondary100
        case .gray: return Color.gray200
        case .lightGray: return Color.gray50
        case .red: return Color.error100
        case .success: return Color.success100
        }
    }

    var weakForegroundColor: Color {
        backgroundColor
    }
}

enum ChipSize {
    case small, large

    var font: Font {
        switch self {
        case .small: return .body3xsmallMedium
        case .large: return .bodyXsmallMedium
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .small: return 8
        case .large: return 10
        }
    }
    
    var verticalPadding: CGFloat {
        switch self {
        case .small: return 3
        case .large: return 5
        }
    }
}

enum ChipStyle {
    case fill, weak
}

struct BakeRoadChip: View {
    let title: String
    let color: ChipColor
    let size: ChipSize
    let style: ChipStyle

    var body: some View {
        Text(title)
            .font(size.font)
            .foregroundColor(style == .fill ? .white : color.weakForegroundColor)
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(style == .fill ? color.backgroundColor : color.weakBackgroundColor)
            )
    }
}
