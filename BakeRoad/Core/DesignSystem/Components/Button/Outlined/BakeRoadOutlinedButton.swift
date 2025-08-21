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
    let leadingIconAction: (() -> Void)?
    let trailingIconAction: (() -> Void)?
    
    init(
        title: String,
        style: BakeRoadOutlinedStyle,
        size: BakeRoadButtonSize,
        isDisabled: Bool = false,
        leadingIcon: Image? = nil,
        trailingIcon: Image? = nil,
        action: @escaping () -> Void,
        leadingIconAction: (() -> Void)? = nil,
        trailingIconAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.style = style
        self.size = size
        self.isDisabled = isDisabled
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.action = action
        self.leadingIconAction = leadingIconAction
        self.trailingIconAction = trailingIconAction
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: size.spacing) {
                if let leadingIcon = leadingIcon {
                    if let leadingIconAction = leadingIconAction {
                        Button(action: leadingIconAction) {
                            leadingIcon.resizable()
                                .frame(width: size.iconSize, height: size.iconSize)
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        leadingIcon.resizable()
                            .frame(width: size.iconSize, height: size.iconSize)
                    }
                }
                
                Text(title)
                    .font(size.font)
                
                if let trailingIcon = trailingIcon {
                    if let trailingIconAction = trailingIconAction {
                        Button(action: trailingIconAction) {
                            trailingIcon.resizable()
                                .frame(width: size.iconSize, height: size.iconSize)
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        trailingIcon.resizable()
                            .frame(width: size.iconSize, height: size.iconSize)
                    }
                }
            }
            .frame(maxWidth: .infinity)
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
