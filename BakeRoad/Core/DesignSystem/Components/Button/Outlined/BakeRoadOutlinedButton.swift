//
//  BakeRoadOutlinedButton.swift
//  BakeRoad
//
//  Created by 이현호 on 6/24/25.
//

import SwiftUI

struct BakeRoadOutlinedButton: View {
    let title: String
    let style: BakeRoadOutlinedStyle
    let size: BakeRoadButtonSize
    let isDisabled: Bool
    let leadingIcon: Image?
    let trailingIcon: Image?
    let action: () -> Void
    
    init(
        title: String,
        style: BakeRoadOutlinedStyle,
        size: BakeRoadButtonSize,
        isDisabled: Bool = false,
        leadingIcon: Image? = nil,
        trailingIcon: Image? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.size = size
        self.isDisabled = isDisabled
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.action = action
    }
    
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
            .background(.white)
            .overlay(
                RoundedRectangle(cornerRadius: size.radius)
                    .stroke(style.borderColor(isDisabled: isDisabled), lineWidth: 1)
            )
            .cornerRadius(size.radius)
        }
        .disabled(isDisabled)
    }
}
