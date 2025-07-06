//
//  BakeRoadSolidButton.swift
//  BakeRoad
//
//  Created by 이현호 on 6/24/25.
//

import SwiftUI

struct BakeRoadSolidButton: View {
    let title: String
    let style: BakeRoadSolidStyle
    let size: BakeRoadButtonSize
    let isDisabled: Bool
    let leadingIcon: Image?
    let trailingIcon: Image?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: size.spacing) {
                if let leadingIcon = leadingIcon {
                    leadingIcon.resizable()
                        .frame(width: size.iconSize, height: size.iconSize)
                }
                Text(title)
                    .font(size.font)
                if let trailingIcon = trailingIcon {
                    trailingIcon.resizable()
                        .frame(width: size.iconSize, height: size.iconSize)
                }
            }
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .foregroundColor(style.textColor(isDisabled: isDisabled))
            .background(style.backgroundColor(isDisabled: isDisabled))
            .cornerRadius(size.radius)
        }
        .disabled(isDisabled)
    }
}

