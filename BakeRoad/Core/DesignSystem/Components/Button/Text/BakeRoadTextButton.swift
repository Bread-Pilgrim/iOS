//
//  BakeRoadTextButton.swift
//  BakeRoad
//
//  Created by 이현호 on 7/16/25.
//

import SwiftUI

enum BakeRoadTextButtonType {
    case primary
    case assistive
}

enum BakeRoadTextButtonSize {
    case medium
    case small

    var font: Font {
        switch self {
        case .medium: return .bodyMediumSemibold
        case .small: return .bodyXsmallSemibold
        }
    }
}

struct BakeRoadTextButton: View {
    let title: String
    let type: BakeRoadTextButtonType
    let size: BakeRoadTextButtonSize
    let isDisabled: Bool?
    let leadingIcon: (() -> AnyView)?
    let trailingIcon: (() -> AnyView)?
    let action: () -> Void

    init(
        title: String,
        type: BakeRoadTextButtonType,
        size: BakeRoadTextButtonSize,
        isDisabled: Bool? = false,
        leadingIcon: (() -> AnyView)? = nil,
        trailingIcon: (() -> AnyView)? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.type = type
        self.size = size
        self.isDisabled = isDisabled
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let leadingIcon = leadingIcon {
                    leadingIcon()
                }

                Text(title)
                    .font(size.font)
                    .foregroundColor(foregroundColor)

                if let trailingIcon = trailingIcon {
                    trailingIcon()
                }
            }
            .padding()
            .background(.white)
        }
        .disabled(isDisabled ?? false)
    }

    private var foregroundColor: Color {
        if isDisabled ?? false {
            return .gray200
        }

        switch type {
        case .primary:
            return .primary500
        case .assistive:
            return .gray800
        }
    }
}
