//
//  BakeRoadAlert.swift
//  BakeRoad
//
//  Created by 이현호 on 6/26/25.
//

import SwiftUI

enum AlertButtonLayout {
    case horizontal
    case vertical
}

struct AlertAction {
    let title: String
    let action: () -> Void
}

struct BakeRoadAlert: View {
    let title: String?
    let message: String?
    let primaryAction: AlertAction
    let secondaryAction: AlertAction?
    let layout: AlertButtonLayout
    
    init(title: String? = nil, message: String? = nil, primaryAction: AlertAction, secondaryAction: AlertAction? = nil, layout: AlertButtonLayout) {
        self.title = title
        self.message = message
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.layout = layout
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                if let title = title {
                    Text(title)
                        .font(.headingSmallBold)
                        .foregroundColor(.gray990)
                }
                if let message = message {
                    Text(message)
                        .font(.bodyXsmallMedium)
                        .foregroundColor(.gray800)
                        .lineSpacing(2)
                }
            }
            .padding(.vertical, 20)
            
            if layout == .horizontal {
                HStack(spacing: 8) {
                    if let secondary = secondaryAction {
                        button(for: secondary, style: .secondary, layout: .horizontal)
                    }
                    button(for: primaryAction, style: .primary, layout: .horizontal)
                }
                .padding(.bottom, 16)
            } else {
                VStack(spacing: 8) {
                    button(for: primaryAction, style: .primary, layout: .vertical)
                    if let secondary = secondaryAction {
                        button(for: secondary, style: .secondary, layout: .vertical)
                    }
                }
                .padding(.bottom, 16)
            }
        }
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
    
    private func button(for action: AlertAction, style: ButtonStyleType, layout: AlertButtonLayout) -> some View {
        let cornerRadius: CGFloat = layout == .horizontal ? 12 : 10
        
        return Button(action: action.action) {
            Text(action.title)
                .font(layout == .horizontal ? .bodyLargeSemibold : .bodyMediumSemibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, layout == .horizontal ? 15.5 : 13)
                .foregroundColor(style.textColor)
                .background(style.backgroundColor)
                .cornerRadius(cornerRadius)
                .if(style == .secondary) { view in
                    view.overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(style.borderColor, lineWidth: 1)
                    )
                }
        }
    }
}

private enum ButtonStyleType {
    case primary, secondary
    
    var textColor: Color {
        switch self {
        case .primary: return .white
        case .secondary: return .primary500
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .primary: return .primary500
        case .secondary: return .white
        }
    }
    
    var borderColor: Color {
        switch self {
        case .primary: return .primary500
        case .secondary: return .gray200
        }
    }
}
