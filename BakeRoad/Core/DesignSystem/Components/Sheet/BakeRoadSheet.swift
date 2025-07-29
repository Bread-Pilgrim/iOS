//
//  BakeRoadSheet.swift
//  BakeRoad
//
//  Created by 이현호 on 6/26/25.
//

import SwiftUI

enum SheetButtonAlignment {
    case horizontal
    case vertical
}

struct SheetAction {
    let title: String
    let action: () -> Void
}

struct BakeRoadSheet<Content: View>: View {
    let title: String
    let message: String?
    let buttonAlignment: SheetButtonAlignment
    let primaryAction: SheetAction
    let secondaryAction: SheetAction?
    let content: Content
    
    init(
        title: String,
        message: String?,
        buttonAlignment: SheetButtonAlignment,
        primaryAction: SheetAction,
        secondaryAction: SheetAction? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.message = message
        self.buttonAlignment = buttonAlignment
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.headingSmallBold)
                    .foregroundColor(.gray990)
                
                if let message = message {
                    Text(message)
                        .font(.bodyXsmallMedium)
                        .foregroundColor(.gray800)
                        .padding(.top, 8)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // 사용자 정의 콘텐츠 삽입 영역
            content
            
            buttonStack
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(20)
        .padding(.horizontal, 8)
    }
    
    @ViewBuilder
    private var buttonStack: some View {
        switch buttonAlignment {
        case .vertical:
            VStack(spacing: 8) {
                primaryButton
                if let secondary = secondaryAction {
                    secondaryButton(secondary)
                }
            }
        case .horizontal:
            HStack(spacing: 8) {
                if let secondary = secondaryAction {
                    secondaryButton(secondary)
                }
                primaryButton
            }
        }
    }

    private var primaryButton: some View {
        Button(action: primaryAction.action) {
            Text(primaryAction.title)
                .font(.bodyMediumSemibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .background(Color.primary500)
                .cornerRadius(10)
        }
    }

    private func secondaryButton(_ action: SheetAction) -> some View {
        Button(action: action.action) {
            Text(action.title)
                .font(.bodyMediumSemibold)
                .foregroundColor(.primary500)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray200, lineWidth: 1)
                )
        }
    }
}
